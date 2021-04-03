import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoMascarado extends StatelessWidget {
  final Icon icone;
  final String hint;
  final String label;
  final bool validate;
  final String text;
  final TextInputFormatter formatter;
  final TextEditingController controller;

  const CampoMascarado({
    Key key,
    this.icone,
    this.hint,
    this.label,
    this.validate,
    @required this.text,
    @required this.formatter,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ( this.text != null) ?
        Container(
          width: MediaQuery.of(context).size.width / 4.5,
          child: Text(
            text,style: const TextStyle(fontSize: 20),
          ),
        )
            :
        Container(),

        ( this.icone != null) ?
        Container(
          width: MediaQuery.of(context).size.width / 8.5,
          child: this.icone,
        )
            :
        Container(),

        Expanded(
          child: TextFormField(
            decoration: new InputDecoration(
              hintText: this.hint,
              labelText: this.label,
              border: InputBorder.none,

            ),
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              formatter,
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if ( this.validate) {
                if (value.isEmpty) {
                  return 'Por favor insira um valor';
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
