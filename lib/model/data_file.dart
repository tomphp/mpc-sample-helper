import 'package:yaml/yaml.dart';

import 'control.dart';

/// Makes the exception a data file throws, from a message naming the entry.
typedef DataError = Exception Function(String message);

/// Rejects misspelt keys, which would otherwise be silently ignored.
void checkKeys(
  String where,
  YamlMap map,
  Set<String> allowed,
  DataError error,
) {
  for (final key in map.keys) {
    if (!allowed.contains(key)) throw error('$where: unknown key "$key"');
  }
}

/// Reads a Control reference, naming the entry if it isn't a Control.
ControlRef parseControlIn(String where, String reference, DataError error) {
  try {
    return ControlRef.parse(reference);
  } on UnknownControlException catch (unknown) {
    throw error('$where: unknown Control "${unknown.reference}"');
  }
}
