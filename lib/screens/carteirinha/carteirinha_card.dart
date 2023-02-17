import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/screens/cadastro/Cadastro_pet_screen.dart';
import 'package:pet_care/screens/informacoes/pet_info_screen.dart';

class CarteirinhaCard extends StatefulWidget {
  final String nome;
  final String data;
  final String dataProxima;
  const CarteirinhaCard({
    Key? key,
    required this.nome,
    required this.data,
    required this.dataProxima,
  }) : super(key: key);

  @override
  _CarteirinhaCardState createState() => _CarteirinhaCardState();
}

class _CarteirinhaCardState extends State<CarteirinhaCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Container(
      width: queryData.size.width,
      height: 110,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.nome,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                "Data: ${widget.data}",
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                "Próxima: ${widget.dataProxima}",
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
