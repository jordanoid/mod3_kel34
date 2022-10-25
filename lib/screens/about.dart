import 'package:flutter/material.dart';
import 'home.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Anggota Kelompok 34',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 80,
            ),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    "assets/splash.jpg",
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      const Card(
                        child: ListTile(
                          title: Text('Muhammad Fariz Sidik'),
                          subtitle: Text('21120120140038'),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          title: Text('Sachiko Fitria Ramandanti'),
                          subtitle: Text('21120120140103'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text('Muhamad Rafdan Maulana'),
                          subtitle: Text('21120120140139'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text('Jordano Iqbal Darmawan'),
                          subtitle: Text('21120120130073'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
