const _separators = ['_', '-', '/', '.', ',', ' '];

const _upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
const _lower = "abcdefghijklmnopqrstuvwxyz";

typedef Transform = Function(int index, StringBuffer out, String word);

void pascalTransform(int index, StringBuffer out, String word) {
  out.write(word[0].toUpperCase());
  out.write(word.substring(1));
}

void camelTransform(int index, StringBuffer out, String word) {
  if (index == 0) {
    out.write(word[0].toLowerCase());
  } else {
    out.write(word[0].toUpperCase());
  }
  out.write(word.substring(1));
}

void lowerTransform(int index, StringBuffer out, String word) {
  out.write(word.toLowerCase());
}

void upperTransform(int index, StringBuffer out, String word) {
  out.write(word.toUpperCase());
}

int _applyTransformation(
  int index,
  StringBuffer out,
  StringBuffer word,
  Transform transform,
  String? separator,
) {
  if (index > 0 && separator != null) {
    out.write(separator);
  }
  transform(index, out, word.toString());
  word.clear();
  return index + 1;
}

String applyCase(String text, String? separator, Transform transform) {
  text = text.trim();

  StringBuffer out = StringBuffer();
  StringBuffer buffer = StringBuffer();
  String? ls;

  int wPos = 0;
  int size = text.length;

  for (int i = 0; i < size; i++) {
    String c = text[i];
    if (_separators.contains(c)) {
      if (buffer.isNotEmpty) {
        wPos = _applyTransformation(wPos, out, buffer, transform, separator);
      }
    } else {
      if (_upper.contains(c) && ls != null && _lower.contains(ls)) {
        wPos = _applyTransformation(wPos, out, buffer, transform, separator);
      }
      buffer.write(c);
    }
    ls = c;
  }
  if (buffer.isNotEmpty) {
    wPos = _applyTransformation(wPos, out, buffer, transform, separator);
  }
  return out.toString();
}

extension StringCasing on String {
  // flatcase
  String get flatCase {
    return applyCase(this, null, lowerTransform);
  }

  // UPPERFLATCASE
  String get upperFlatCase {
    return applyCase(this, null, upperTransform);
  }

  // camelCase
  String get camelCase {
    return applyCase(this, null, camelTransform);
  }

  // PascalCase
  String get pascalCase {
    return applyCase(this, null, pascalTransform);
  }

  // snake_case
  String get snakeCase {
    return applyCase(this, _separators[0], lowerTransform);
  }

  // camel_Snake_Case
  String get camelSnakeCase {
    return applyCase(this, _separators[0], camelTransform);
  }

  // Pascal_Snake_Case
  String get pascalSnakeCase {
    return applyCase(this, _separators[0], pascalTransform);
  }

  // kebab-case
  String get kebabCase {
    return applyCase(this, _separators[1], lowerTransform);
  }

  // SCREAMING-KEBAB-CASE
  String get screamingKebabCase {
    return applyCase(this, _separators[1], upperTransform);
  }

  // Header-Case
  String get headerCase {
    return applyCase(this, _separators[1], pascalTransform);
  }
}
