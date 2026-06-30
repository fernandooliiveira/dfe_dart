import 'package:xml/xml.dart';

/// Inclusive Canonical XML 1.0 (http://www.w3.org/TR/2001/REC-xml-c14n-20010315).
///
/// Limitado ao subconjunto necessário para assinatura NF-e: UTF-8, sem
/// instruções de processamento externas, sem comentários, sem DTD.
String canonicalize(XmlElement element) {
  // Coleta namespaces declarados nos ancestrais (do root até o pai imediato)
  final inherited = <String, String>{};
  _collectAncestorNs(element, inherited);

  final sb = StringBuffer();
  // alreadyOutput rastreia o que já foi escrito na saída C14N, não declarado no XML original
  _c14nElement(element, sb, inherited, <String, String>{});
  return sb.toString();
}

/// Coleta namespaces declarados nos ancestrais de [element] (sem incluir o próprio).
void _collectAncestorNs(XmlElement element, Map<String, String> ns) {
  final path = <XmlElement>[];
  XmlNode? node = element.parent;
  while (node is XmlElement) {
    path.add(node);
    node = node.parent;
  }
  // Da raiz para o pai imediato
  for (final ancestor in path.reversed) {
    for (final attr in ancestor.attributes) {
      _extractNsDecl(attr, ns);
    }
  }
}

void _extractNsDecl(XmlAttribute attr, Map<String, String> ns) {
  if (attr.name.prefix == null && attr.name.local == 'xmlns') {
    ns[''] = attr.value;
  } else if (attr.name.prefix == 'xmlns') {
    ns[attr.name.local] = attr.value;
  }
}

/// Serializa recursivamente [el] em forma canônica.
///
/// [inheritedNs] — namespaces em escopo herdados dos ancestrais no XML original.
/// [outputNs]   — namespaces já escritos na saída C14N (compartilhado mutable ao longo da travessia).
void _c14nElement(XmlElement el, StringBuffer sb, Map<String, String> inheritedNs,
    Map<String, String> outputNs) {
  // Escopo completo de namespaces neste elemento
  final scope = <String, String>{...inheritedNs};
  for (final attr in el.attributes) {
    _extractNsDecl(attr, scope);
  }

  sb.write('<');
  sb.write(el.name.qualified);

  // ── Namespace declarations ───────────────────────────────────────────────
  // Em C14N inclusivo, declaramos todos os namespaces em escopo que são
  // "visibly utilized" pelo nome do elemento ou de seus atributos, e que
  // ainda não foram escritos na saída.
  final nsToWrite = <String, String>{};

  // Namespace do próprio elemento
  final elUri = el.name.namespaceUri ?? '';
  final elPrefix = el.name.prefix ?? '';
  if (elUri.isNotEmpty && outputNs[elPrefix] != elUri) {
    nsToWrite[elPrefix] = elUri;
  }

  // Namespaces dos atributos (excluindo declarações xmlns)
  for (final attr in el.attributes) {
    if (attr.name.prefix == 'xmlns' ||
        (attr.name.prefix == null && attr.name.local == 'xmlns')) {
      continue;
    }
    final attrUri = attr.name.namespaceUri ?? '';
    final attrPrefix = attr.name.prefix ?? '';
    if (attrUri.isNotEmpty && outputNs[attrPrefix] != attrUri) {
      nsToWrite[attrPrefix] = attrUri;
    }
  }

  // Namespace padrão em escopo que precisa ser propagado se não foi escrito
  // (cobre o caso de herança sem uso direto — pouco comum mas necessário para C14N)
  if (scope.containsKey('') && outputNs[''] != scope['']) {
    nsToWrite.putIfAbsent('', () => scope['']!);
  }

  // Ordena: namespace padrão primeiro, depois por prefixo
  final sorted = nsToWrite.entries.toList()
    ..sort((a, b) {
      if (a.key == '') return -1;
      if (b.key == '') return 1;
      return a.key.compareTo(b.key);
    });

  for (final e in sorted) {
    if (e.key == '') {
      sb.write(' xmlns="${_escapeAttr(e.value)}"');
    } else {
      sb.write(' xmlns:${e.key}="${_escapeAttr(e.value)}"');
    }
    outputNs[e.key] = e.value;
  }

  // ── Non-namespace attributes (sorted alphabetically) ────────────────────
  final nonNsAttrs = el.attributes
      .where((a) =>
          a.name.prefix != 'xmlns' &&
          !(a.name.prefix == null && a.name.local == 'xmlns'))
      .toList()
    ..sort((a, b) => a.name.qualified.compareTo(b.name.qualified));

  for (final attr in nonNsAttrs) {
    sb.write(' ${attr.name.qualified}="${_escapeAttr(attr.value)}"');
  }

  sb.write('>');

  // ── Children ─────────────────────────────────────────────────────────────
  for (final child in el.children) {
    if (child is XmlElement) {
      _c14nElement(child, sb, scope, outputNs);
    } else if (child is XmlText) {
      sb.write(_escapeText(child.value));
    }
    // Comentários e PIs são omitidos conforme common NF-e practice
  }

  sb.write('</${el.name.qualified}>');
}

String _escapeText(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('\r', '&#xD;');

String _escapeAttr(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('"', '&quot;')
    .replaceAll('\t', '&#x9;')
    .replaceAll('\n', '&#xA;')
    .replaceAll('\r', '&#xD;');
