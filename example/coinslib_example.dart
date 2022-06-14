import 'package:coinslib/coinslib.dart';
import 'package:bip39/bip39.dart' as bip39;

main() {
  final alice = ECPair.fromWIF(
      'cNGupyDhyzw44RKfNX61uWYeywc1Rbw6ozpZrvpBNEgG7R1jconA',
      network: regtest);

  final txb = new TransactionBuilder(network: regtest);
  final p2wpkh = new P2WPKH(
          data: new PaymentData(pubkey: alice.publicKey), network: regtest)
      .data;

  print(p2wpkh.output);

  txb.setVersion(1);
  print(p2wpkh.address);
  print(p2wpkh.witness);
  //print(Address.addressToOutputScript(p2wpkh.address, regtest));

  txb.addInput(
      '31ea54998f26129bffe2c4ee53c3aa4614195f11b4aa770bf0e5eae78c8d35b4',
      0,
      null,
      p2wpkh.output); // Alice's previous transaction output, has 15000 satoshis
  print(txb.inputs[0].prevOutType);
  txb.addNullOutput('ADD:BTC.BTC:tthor1zf3gsk7edzwl9syyefvfhle37cjtql35h6k85m');
  txb.addOutput(
      'bcrt1qwag6j309wc4r0g0kvq8lke64uks6vv55pd2ewq', 78100000);

  txb.sign(vin: 0, keyPair: alice, witnessValue: 78125000);

  print(txb.tx.outs[0].script);

  print(txb.build().toHex());
}
