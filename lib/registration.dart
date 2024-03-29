import 'package:find_your_restaurant/restaurant_owner_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:find_your_restaurant/customer_form.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registration',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Colors.orange,
            shadows: [
              Shadow(
                color: Color.fromARGB(255, 181, 112, 27),
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: const Image(
          image: AssetImage(
            'assets/images/156757283_Bedford_Hotel__F_B__Botanica_Restaurant_and_Bar__General_View._4500x3000.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 100),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/834071-too-restaurant-too-hotel-paris-photos-menu-entrees.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Are you a?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantOwnerForm(
                        onMapCreated: (controller) {},
                      ),
                    ),
                  );
                },
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: Colors.green,
                // ),
                child: const Text(
                  'Restaurant Owner',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerForm(),
                    ),
                  );
                },
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: Colors.blue,
                // ),
                child: const Text(
                  'Customer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
