import 'package:flutter/material.dart';

class CalendarioHorizontalWidget extends StatefulWidget {
  List lista;
  final void Function(String) onSubmit;
  CalendarioHorizontalWidget(this.lista, this.onSubmit);

  @override
  _CalendarioHorizontalWidgetState createState() => _CalendarioHorizontalWidgetState();
}

class _CalendarioHorizontalWidgetState extends State<CalendarioHorizontalWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ANTERIOR ANO
              InkWell(
                onTap: (){ widget.onSubmit( "anterior-ano".toString() ); },
                child:Container(
                    height: 50,
                    child: Center(
                        child: Icon(Icons.first_page)
                    )
                ),
              ),

              // ANTERIOR MES
              InkWell(
                onTap: (){ widget.onSubmit( "anterior-mes".toString() ); },
                child:Container(
                    width: MediaQuery.of(context).size.width * .24,
                    height: 30,
                    child: Center(
                        child: Text("${widget.lista[0].mesAbreviado} ${widget.lista[0].ano}",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),),
                    ),
                ),
              ),

              // CENTRO
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black26,
                  ),
                  width: MediaQuery.of(context).size.width * .25,
                  height: 50,
                  child: Center(
                    child: Text("${widget.lista[1].mesAbreviado} ${widget.lista[1].ano}" , style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  )
              ),

              // POSTERIOR MES
              InkWell(
                onTap: (){ widget.onSubmit( "posterior-mes".toString() ); },
                child: Container(
                    width: MediaQuery.of(context).size.width * .24,
                    height: 30,
                    child: Center(
                      child: Text("${widget.lista[2].mesAbreviado} ${widget.lista[2].ano}",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),),
                    )
                ),
              ),

              // POSTERIOR ANO
              InkWell(
                onTap: (){ widget.onSubmit( "posterior-ano".toString() ); },
                child:Container(
                    height: 50,
                    child: Center(
                        child: Icon(Icons.last_page)
                    )
                ),
              ),
            ],
          ),
          // Divider(),
        ],
      ),
    );
  }
}
