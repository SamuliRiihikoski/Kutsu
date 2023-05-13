import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(height: 50),
                Text(
                  'Tämän sovelluksen avulla voit luoda kutsun lähellä'
                  ' oleville ihmisille. Kutsuja on momenlaisia. Onko etsinnässä kaveri urheiluharrastuksiin, teatteriin tai vaikka rantabileisiin. Vai haluatko ilmoittaa tapahtumasta sinun lähelläsi.'
                  ' Kutsun luomisen jälkeen ihmiset lähelläsi voivat tykätä kutsustasi ja sinä valitset henkilön, jonka kanssa jatkaa kesustelua.',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Olethan ystävällinen täällä tapaamiin ihmisiä kohtaan.'
                  ' Voit antaa palautetta lähettämällä viestin osoitteeseen samuli.riihi@gmail.com',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Text(
                  'Takaisin',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          context.pop();
        },
      ),
    );
  }
}
