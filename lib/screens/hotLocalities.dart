import 'package:flutter/material.dart';
import 'package:proser/screens/hot_locality_model.dart';
import 'package:proser/screens/hot_locality_ApiService.dart';
import 'package:proser/screens/PropertyScreen.dart';
import 'package:proser/utils/color.dart';

class HotLocalitiesPage extends StatefulWidget {
  final String slug;

  const HotLocalitiesPage({super.key, required this.slug});

  @override
  State<HotLocalitiesPage> createState() => _HotLocalitiesPageState();
}

class _HotLocalitiesPageState extends State<HotLocalitiesPage> {
  late Future<HotLocalityDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = LocalityService.fetchHotLocalityDetail(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HotLocalityDetail>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("Failed to load data")),
          );
        }

        final data = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            centerTitle: true,
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                data.name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
            actions: const [
              Icon(Icons.arrow_forward_ios),
              SizedBox(width: 16),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(data.descriptionTop, style: const TextStyle(height: 1.5)),
              const SizedBox(height: 10),
              const SizedBox(height: 20),

              const Text(
                'Recommended Properties',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildPropertiesList(data.projects),
              Text(data.descriptionBottom, style: const TextStyle(height: 1.5)),
              const SizedBox(height: 20),
              
              
            ],
          ),
        );
      },
    );
  }

  Widget _buildPropertiesList(List<HotLocalityProject> projects) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final p = projects[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => PropertyScreen(
      slug: p.slug,
      propertyTitle: p.title,
      builderName: p.byLabel,
      imageUrl: p.imageUrl,
      builderLogo: p.logo,
    ),
  ),
);

            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      p.imageUrl,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1),
                        Text(p.byLabel, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1),
                        const SizedBox(height: 4),
                        Text("Ready by ${p.possession}", style: const TextStyle(fontSize: 11)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_pin, color: Colors.green, size: 14),
                            Expanded(
                              child: Text(p.location, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 6),
                            Text(p.bhk, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Starts from ${p.priceRange}",
                            style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
