import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty || args.first == 'help') {
    _printUsage();
    return;
  }

  switch (args.first) {
    case 'keygen':
      await _keygen();
    case 'sign':
      await _sign(args.skip(1).toList());
    default:
      stderr.writeln('Unknown command: ${args.first}');
      _printUsage();
      exitCode = 64;
  }
}

Future<void> _keygen() async {
  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPair();
  final keyPairData = await keyPair.extract();
  final publicKey = await keyPair.extractPublicKey();

  stdout.writeln('Private seed base64: ${base64Encode(keyPairData.bytes)}');
  stdout.writeln('Public key base64:   ${base64Encode(publicKey.bytes)}');
  stdout.writeln('');
  stdout.writeln(
    'Keep the private seed secret. Embed only the public key in app builds.',
  );
}

Future<void> _sign(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Missing arguments for sign.');
    _printUsage();
    exitCode = 64;
    return;
  }

  final manifestFile = File(args[0]);
  final privateSeed = base64Decode(args[1]);
  final outputFile = args.length >= 3 ? File(args[2]) : manifestFile;
  final decoded =
      jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
  final payload = Map<String, dynamic>.from(decoded)..remove('signature');
  final message = utf8.encode(jsonEncode(payload));

  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPairFromSeed(privateSeed);
  final signature = await algorithm.sign(message, keyPair: keyPair);
  final signed = {...payload, 'signature': base64Encode(signature.bytes)};

  const encoder = JsonEncoder.withIndent('  ');
  await outputFile.writeAsString('${encoder.convert(signed)}\n');
  stdout.writeln('Signed manifest written to ${outputFile.path}');
}

void _printUsage() {
  stdout.writeln('''
jUNGLE manifest utility

Usage:
  dart run tool/jungle_manifest.dart keygen
  dart run tool/jungle_manifest.dart sign <apps.json> <private-seed-base64> [output.json]

The app verifies remote manifests by removing the top-level signature field,
JSON-encoding the remaining object, and checking the Ed25519 signature.
''');
}
