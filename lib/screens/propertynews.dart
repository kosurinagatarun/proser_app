import 'package:flutter/material.dart';
import 'package:proser/utils/color.dart';

class PropertyNewsPage extends StatelessWidget {
  const PropertyNewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: const [
          Icon(
            Icons.facebook,
            color: primaryGreen,
            size: 30,
          ),
          SizedBox(width: 15),
          Icon(Icons.share, color: primaryGreen, size: 25),
          SizedBox(width: 10),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'What Is Home Automation?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Posted on 1 Feb 2025'),
          const SizedBox(height: 16),
          Image.asset('assets/images/home_automation.png'),
          const SizedBox(height: 16),
          const Text(
            "Let’s start with the basics – what is home automation?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
              "• Home automation is a technology that lets users create and trigger automatic functions for home devices. That may be through schedules, rules, or scenes. With scheduled automations, for example, you can make lights turn on at a certain time. Using rules, you can make your devices respond to certain actions of yours or scenarios (e.g. turn on lights when a door is opened)."),
          const Text(
              "• And with scenes, you can group together home devices so each of them perform a specific action whenever you trigger the scene. That means you can control multiple devices with just a touch of a button."),
          const Text(
              "• Home automation makes life more convenient and can even save you money on heating, cooling and electricity bills. Home automation can also lead to greater safety with Internet of Things devices like security cameras and systems. But hold up; what’s the Internet of Things?"),
          const SizedBox(height: 24),

          // Centered Portrait Image (device.png)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/device.png',
                width: 350,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Things vs. Home Automation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
              "• From a broader perspective, an Internet of Things or IoT device is any device that connects to the internet, allowing it to communicate with other devices."),
          const Text(
              "• Normally, that’s your laptop, smartphone, or tablet. But in smart homes, IoT devices come in myriads of forms. For example, your smart TV is an IoT. So are your smart bulbs, smart lock, smart thermostat, and so on."),
          const Text(
              "• Basically, any device that connects to the internet and communicates with other devices is considered an IoT device."),
          const Text(
              "• In contrast, home automation is the process of automating a home device. Even a good ol’ programmable thermostat is a home automation device because you can automate it by setting schedules. Anything that you can automate is a home automation device."),
          const SizedBox(height: 16),

          Card(
            margin: const EdgeInsets.only(top: 16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/anurag.jpg'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Mr Anurag,',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'CEO, Aparna Infra',
                        style: TextStyle(color: Colors.red),
                      ),
                      Text('Know more about the Publisher'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // 👈 smaller radius
                  ),
                ),
                child: const Text("Previous"),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // 👈 smaller radius
                  ),
                ),
                child: const Text("Next"),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Browse more Articles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Column(
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/device.png',
                        width: 100,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "From a broader perspective, an Internet of Things or IoT device is any device that connects to the internet, allowing it to communicate with other devices.",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Published by Anurag",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
