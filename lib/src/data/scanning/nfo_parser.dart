import 'package:xml/xml.dart';

class ParsedNfo {
  const ParsedNfo({
    this.title,
    this.plot,
    this.code,
    this.actors = const <String>[],
  });

  final String? title;
  final String? plot;
  final String? code;
  final List<String> actors;
}

class NfoParser {
  ParsedNfo parse(String content) {
    if (content.trim().isEmpty) {
      return const ParsedNfo();
    }

    try {
      final document = XmlDocument.parse(content);
      final root = document.rootElement;
      final title = _firstText(root, const ['title', 'originaltitle']);
      final plot = _firstText(root, const ['plot', 'outline']);
      final code = _firstText(root, const ['num', 'code', 'id']);
      final actors = root
          .findAllElements('actor')
          .map((actor) => _firstText(actor, const ['name']))
          .whereType<String>()
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(growable: false);

      return ParsedNfo(title: title, plot: plot, code: code, actors: actors);
    } catch (_) {
      return const ParsedNfo();
    }
  }

  String? _firstText(XmlElement root, List<String> candidates) {
    for (final candidate in candidates) {
      final element = root.getElement(candidate);
      final text = element?.innerText.trim();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }
    return null;
  }
}
