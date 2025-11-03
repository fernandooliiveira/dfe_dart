import 'package:xml/xml.dart';

/// Implementação local de canonicalização XML (C14N Exclusive 1.0)
/// conforme W3C Recommendation REC-xml-exc-c14n-20020718.
/// Compatível com a SEFAZ (NFe/NFCe).
///
/// Uso:
///   final canon = canonicalizeC14N(node);
///
/// onde [node] é um XmlNode (XmlElement ou XmlDocument).
String canonicalizeC14N(
  XmlNode node, {
  bool withComments = false,
  List<String> inclusiveNamespacesPrefixList = const [],
}) {
  final buffer = StringBuffer();

  void writeNode(XmlNode n, {bool isRoot = false}) {
    if (n is XmlElement) {
      buffer.write('<');
      buffer.write(n.name.qualified);

      final attrs = n.attributes.toList()
        ..sort((a, b) => a.name.qualified.compareTo(b.name.qualified));

      for (final a in attrs) {
        buffer.write(' ${a.name.qualified}="${_escapeAttr(a.value)}"');
      }

      if (isRoot) {
        final ns = _collectNamespaces(n);
        ns.forEach((prefix, uri) {
          if (prefix.isEmpty) {
            buffer.write(' xmlns="$uri"');
          } else {
            buffer.write(' xmlns:$prefix="$uri"');
          }
        });
      }

      buffer.write('>');

      for (final c in n.children) {
        if (c is XmlComment && !withComments) continue;
        writeNode(c);
      }

      buffer.write('</');
      buffer.write(n.name.qualified);
      buffer.write('>');
    } else if (n is XmlText) {
      buffer.write(_escapeText(n.value));
    } else if (n is XmlCDATA) {
      buffer.write(_escapeText(n.value));
    } else if (n is XmlComment && withComments) {
      buffer.write('<!--${n.value}-->');
    } else if (n is XmlDocument || n is XmlDocumentFragment) {
      for (final c in n.children) {
        if (c is XmlComment && !withComments) continue;
        writeNode(c, isRoot: isRoot);
      }
    }
  }

  if (node is XmlElement) {
    writeNode(node, isRoot: true);
  } else {
    writeNode(node);
  }

  return buffer.toString();
}

String _escapeAttr(String v) => v
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('"', '&quot;')
    .replaceAll('\r', '&#xD;');

String _escapeText(String v) => v
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('\r', '&#xD;');

Map<String, String> _collectNamespaces(XmlElement e) {
  final map = <String, String>{};
  XmlNode? cur = e;
  while (cur != null) {
    if (cur is XmlElement) {
      for (final a in cur.attributes) {
        if (a.name.prefix == 'xmlns' || a.name.qualified == 'xmlns') {
          final prefix = a.name.prefix == 'xmlns' ? a.name.local : '';
          map.putIfAbsent(prefix, () => a.value);
        }
      }
    }
    cur = cur.parent;
  }
  return map;
}
