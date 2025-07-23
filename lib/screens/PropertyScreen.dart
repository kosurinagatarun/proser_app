// 🔄 Fade Animation Fix for Left Toggle Button (Center & Smooth Transition)
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:proser/api/property_api.dart';
import 'package:proser/api/property_model.dart';
import 'package:proser/screens/components/allReviews.dart';
import 'package:proser/screens/components/constant.dart';
import 'package:proser/screens/components/hotspotsMap.dart';
import 'package:proser/screens/mapScreen.dart';
import 'package:proser/screens/navigation_screen.dart';
import 'package:proser/utils/color.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  const FullScreenImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true,
            scaleEnabled: true,
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child: Hero(
                tag: imageUrl,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Close "X" button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, size: 30, color: Colors.white),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Close',
            ),
          ),
        ],
      ),
    );
  }
}



class ContactBuilderDialog extends StatefulWidget {
  const ContactBuilderDialog({Key? key}) : super(key: key);

  @override
  State<ContactBuilderDialog> createState() => _ContactBuilderDialogState();
}

class _ContactBuilderDialogState extends State<ContactBuilderDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField("Your name", nameController),
            const SizedBox(height: 10),
            _buildTextField("Mobile Number", phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 10),
            _buildTextField("Please Share anything..!", messageController, maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // ✅ close the dialog
                  // You can handle submit logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        isDense: true,
        border: const UnderlineInputBorder(),
      ),
    );
  }
}



class PDFViewPage extends StatelessWidget {
  final String pdfUrl;

  const PDFViewPage({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Brochure")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(pdfUrl)),
      ),
    );
  }
}


class PropertyScreen extends StatefulWidget {
  final String propertyTitle;
  final String builderName;
  final String imageUrl;
  final String builderLogo;
  final String slug;


const PropertyScreen({
  Key? key,
  required this.slug,
  required this.propertyTitle,
  required this.builderName,
  required this.imageUrl,
  required this.builderLogo,
}) : super(key: key);


  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  bool showCapsule = false;
  bool showFullGallery = false;
  int initialGalleryIndex = 0;
  bool showProjectDetails = true;
  bool showFullDescription = false;
  bool showFullWhy = false;
  Property? property;
  bool isLoading = true;
  bool isError = false;
  //List<String> galleryImages = []; 
  int? zoomedIndex;  



  @override
void initState() {
  super.initState();
  loadPropertyDetails();
}

void _openGalleryAt(int startIndex) {
  setState(() {
    showFullGallery = true;   // show the overlay
    zoomedIndex     = startIndex;   // start in zoom mode on that image
  });
}


Future<List<dynamic>> fetchProjectData() async {
  final response = await http.get(Uri.parse(
    "${AppConstants.baseUrl1}/api/v1/projects/apartment-buy",
  ));
  final decoded = jsonDecode(response.body);
  if (decoded['success'] == true) {
    return decoded['data'];
  } else {
    throw Exception("Failed to fetch project data");
  }
}



Future<void> loadPropertyDetails() async {
  try {
    debugPrint("Fetching property details for slug: ${widget.slug}");
    final fetchedProperty = await fetchPropertyBySlug(widget.slug);
    debugPrint("Fetched property: ${fetchedProperty.title}");
    setState(() {
      property = fetchedProperty;
      galleryImages = property!.galleryImages;
      isLoading = false;
    });
  } catch (e, stacktrace) {
    debugPrint("Error loading property details: $e");
    debugPrint("Stack: $stacktrace");
    setState(() {
      isError = true;
      isLoading = false;
    });
  }
}




List<String> galleryImages = [];



Future<File> _loadPDFAsset() async {
  final bytes = await rootBundle.load('assets/pdfs/brochure.pdf');
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/brochure.pdf');
  await file.writeAsBytes(bytes.buffer.asUint8List());
  return file;
}

@override
Widget build(BuildContext context) {
  if (isLoading) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  if (isError) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text("Failed to load property details")),
    );
  }

  if (property == null) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text("No property data available")),
    );
  }
  return Scaffold(
    backgroundColor: Colors.grey.shade200,
    body: Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 550,
              pinned: false,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                   clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
  child: GestureDetector(
    onTap: () => _openGalleryAt(0),     // index 0 is the hero image
    child: widget.imageUrl.startsWith("http")
      ? Image.network(
          widget.imageUrl,
          key: ValueKey<String>(widget.imageUrl),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/default.png',
              fit: BoxFit.cover,
            );
          },
        )
      : Image.asset(
          widget.imageUrl,
          key: ValueKey<String>(widget.imageUrl),
          fit: BoxFit.cover,
        ),
),)
,
                    // Top Section with Title, Builder, Back and Capsule
                    Positioned(
  top: 50,
  left: 0,
  right: 0,
  child: Stack(
    alignment: Alignment.center,
    clipBehavior: Clip.none, 
    children: [
      // 🔙 Back Button (left)
      Positioned(
        left: 16,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),

      // 🏷 Title + Builder (center)
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.propertyTitle,
            style: const TextStyle(
              fontFamily: "RedGlass",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            widget.builderName,
            style: const TextStyle(
              fontFamily: "Progress",
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),

      // ⋮ Capsule Button (right)
      Positioned(
        top: 10,
        right: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showCapsule = !showCapsule;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => SizeTransition(
                sizeFactor: animation,
                axis: Axis.vertical,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: showCapsule
                  ? Container(
                      key: const ValueKey("capsule"),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.favorite_border, color: Colors.white),
                          SizedBox(height: 8),
                          Icon(Icons.share, color: Colors.white),
                          SizedBox(height: 8),
                          Icon(Icons.compare_arrows, color: Colors.white),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    ],
  ),
),


                    // Project Details Toggle (Left Capsule)
                    Positioned(
                      top: 165,
                      left: 0,
                      child: SizedBox(
                        height: 320,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: showProjectDetails
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: Container(
                                width: 140,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                child: () {
  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  if (isError) {
    return const Center(child: Text("Failed to load project details"));
  }
  if (property == null) {
    return const Center(child: Text("No data available"));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _InfoRow(
        title: "Project Size",
        value: property!.projectSize.isNotEmpty ? property!.projectSize : "--",
      ),
      const SizedBox(height: 10),
      _InfoRow(
        title: "No. of Units",
        value: property!.noOfUnits > 0 ? "${property!.noOfUnits} Units" : "--",
      ),
      const SizedBox(height: 10),
      _InfoRow(
        title: "Possession By",
        value: property!.possession.isNotEmpty ? property!.possession : "--",
      ),
      const SizedBox(height: 10),
      _InfoRow(
        title: "Configurations",
        value: property!.configuration.isNotEmpty ? property!.configuration : "--",
      ),
      const SizedBox(height: 10),
      _InfoRow(
        title: "Available Sizes",
        value: property!.sizeAvailable.isNotEmpty ? property!.sizeAvailable : "--",
      ),
      const SizedBox(height: 10),
      _InfoRow(
        title: "Base Price",
        value: property!.basePrice.isNotEmpty ? property!.basePrice : "--",
      ),
      const SizedBox(height: 10),
    ],
  );
}(),



                              ),
                              secondChild: const SizedBox(width: 0),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showProjectDetails = !showProjectDetails;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Icon(
                                  showProjectDetails ? Icons.chevron_left : Icons.chevron_right,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Gallery Thumbnails
                    Positioned(
                      bottom: 20,
                      right: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (galleryImages.length > 2)
  ...List.generate(2, (index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          initialGalleryIndex = index + 1;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: Container(
          key: ValueKey(galleryImages[index + 1]),
          margin: const EdgeInsets.only(bottom: 8),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(
                galleryImages[index + 1].startsWith("http")
                    ? galleryImages[index + 1]
                    : "${AppConstants.baseUrl}${galleryImages[index + 1]}",
              ),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  })
else
  const SizedBox.shrink(),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showFullGallery = true;
                                zoomedIndex = null; 
                                initialGalleryIndex = galleryImages.isNotEmpty ? 0 : 0;
                              });
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.6),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Text(
                                "+2",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Content Sections
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 8),
                  _buildSectionType(),
                  _buildSectionType1(),
                  _buildSectionType2(),
                  _buildSectionType3(),
                  _buildSectionType4(),
                  _buildSectionType5(),
                  _buildSectionType6(),
                  _buildSectionType7(),
                  _buildSectionType8(),
                  _buildSectionType9(),
                  const SizedBox(height: 15),
                  _buildSectionType10(),
                  _buildSectionType11(),
                  _buildSectionType12(),
                  _buildSectionType13(),
                  _buildSectionType14(context),
                  _buildSectionType20(context),
                  _buildSectionType21(context),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),

        // Fullscreen Gallery Viewer
        // Full‑screen Gallery Viewer
// Full‑screen Gallery Overlay  ────────────────────────────────────────────
if (showFullGallery && galleryImages.isNotEmpty)
  Positioned.fill(
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ───────────  A. COLUMN VIEW  ───────────
          if (zoomedIndex == null)
            ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: galleryImages.length,
              itemBuilder: (context, index) {
                final img = galleryImages[index].startsWith("http")
                    ? galleryImages[index]
                    : "${AppConstants.baseUrl}${galleryImages[index]}";
                return GestureDetector(
                  onTap: () => setState(() => zoomedIndex = index),
                  child: Hero(
                    tag: 'gallery$index',
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.45, // 45 % ⇒ 2 full + ½ third
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(img),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )

          // ───────────  B. ZOOM VIEW  ───────────
          else
            PhotoView(
              imageProvider: NetworkImage(
                galleryImages[zoomedIndex!].startsWith("http")
                    ? galleryImages[zoomedIndex!]
                    : "${AppConstants.baseUrl}${galleryImages[zoomedIndex!]}",
              ),
              heroAttributes:
                  PhotoViewHeroAttributes(tag: 'gallery$zoomedIndex'),
              backgroundDecoration:
                  const BoxDecoration(color: Colors.black),
              onTapUp: (c, d, v) =>
                  setState(() => zoomedIndex = null), // single‑tap to go back
            ),

          // ───────────  C. CONTROL BAR  ───────────
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back arrow only in zoom mode
                if (zoomedIndex != null)
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        size: 28, color: Colors.white),
                    onPressed: () => setState(() => zoomedIndex = null),
                  )
                else
                  const SizedBox(width: 48), // keeps ✕ centred

                // Close button (always available)
                IconButton(
                  icon: const Icon(Icons.close,
                      size: 28, color: Colors.white),
                  onPressed: () => setState(() {
                    showFullGallery = false;
                    zoomedIndex = null;
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  )



      ],
    ),
  );
}


  Widget _sectionCard(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 8),
            Text(description,
                style: const TextStyle(fontSize: 15, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

Widget _buildSectionType() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🗺️ Tapable Blur Map
              GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          latitude: double.tryParse(property?.geoLatitude ?? "0") ?? 0.0,
          longitude: double.tryParse(property?.geoLongitude ?? "0") ?? 0.0,
          address: property?.geoAddress ?? "No address",
        ),
      ),
    );
  },
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey, // border color
        width: 1,           // border thickness
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          SizedBox(
            height: 100,
            width: 180,
            child: AbsorbPointer(
              absorbing: true,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.tryParse(property?.geoLatitude ?? "0") ?? 0.0,
                    double.tryParse(property?.geoLongitude ?? "0") ?? 0.0,
                  ),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('propertyPin'),
                    position: LatLng(
                      double.tryParse(property?.geoLatitude ?? "0") ?? 0.0,
                      double.tryParse(property?.geoLongitude ?? "0") ?? 0.0,
                    ),
                  ),
                },
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                myLocationEnabled: false,
              ),
            ),
          ),
          Container(
            height: 100,
            width: 180,
            color: Colors.white.withOpacity(0.4), // subtle blur
          ),
          const Positioned.fill(
            child: Center(
              child: Icon(Icons.touch_app, color: Colors.black54),
            ),
          )
        ],
      ),
    ),
  ),
),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      property?.geoAddress ?? "--",
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const ContactBuilderDialog();
                              },
                            );
                          },
                          icon: const Icon(Icons.phone_outlined, size: 18, color: Colors.white),
                          label: const Text("Contact Builder"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.ios_share, color: Colors.black),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}



Widget _buildSectionType1() {
  final aboutText = property?.aboutText ?? "--"; // from property model
  final knowAboutBuilder = property?.knowAboutBuilder ?? "--";

  // split text on period or newline for bullet points
  final aboutPoints = aboutText
      .split(RegExp(r'[.\n]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  final showViewMoreToggle = aboutPoints.length > 2;

  final displayPoints = showFullDescription || !showViewMoreToggle
      ? aboutPoints
      : aboutPoints.take(2).toList();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 2, 2, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Builder Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "About the project",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("About the Builder"),
                        content: SingleChildScrollView(
                          child: Text(knowAboutBuilder),
                        ),

                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  "Know about the builder",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          // Bullet Points
          ...displayPoints.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "• ",
                      style: TextStyle(fontSize: 15, height: 1.4, color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 2),

          // View More / Less
          if (showViewMoreToggle)
            GestureDetector(
              onTap: () {
                setState(() {
                  showFullDescription = !showFullDescription;
                });
              },
              child: Row(
                children: [
                  Icon(
                    showFullDescription
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    showFullDescription ? "View Less" : "View More",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    ),
  );
}

Widget _buildSectionType2() {
  final points = property?.whyPoints ?? [];

  final hasViewMore = points.length > 3;
  final shownPoints = showFullWhy || !hasViewMore ? points : points.take(3).toList();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 2, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "Why ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
              children: [
                TextSpan(
                  text: widget.propertyTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              shownPoints.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, color: primaryGreen, size: 15),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(shownPoints[index]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (hasViewMore)
            GestureDetector(
              onTap: () {
                setState(() {
                  showFullWhy = !showFullWhy;
                });
              },
              child: Row(
                children: [
                  Icon(
                    showFullWhy ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    showFullWhy ? "View Less" : "View More",
                    style: const TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildSectionType3() {
  final offers = property?.offers ?? [];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 2, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎁 Title with Icon
          Row(
            children: const [
              Icon(Icons.local_offer_rounded, color: Colors.deepOrange),
              SizedBox(width: 6),
              Text(
                "Offers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 🎁 Offer List
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              offers.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.card_giftcard,
                          color: Colors.redAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        offers[index],
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSectionType4() {
  if (property == null) {
    return const SizedBox.shrink();
  }

  final details = property!.details;

  final projectDetails = [
    {"label": "No. of Flats", "key": "no_of_flats"},
    {"label": "Configurations", "key": "configurations"},
    {"label": "Price/Sq.Ft", "key": "price_per_sqft"},
    {"label": "No. of Floors", "key": "no_of_floors"},
    {"label": "Launch Date", "key": "launch_date"},
    {"label": "Club House Size", "key": "club_house_size"},
    {"label": "Open Space", "key": "open_space"},
    {"label": "RERA", "key": "rera_id"},
    {"label": "Project Type", "key": "project_type"},
    {"label": "Construction", "key": "construction_type"},
    {"label": "No. of Towers", "key": "no_of_towers"},
    {"label": "Possession by", "key": "possession_by"},
    {"label": "Unit sizes", "key": "unit_sizes"},
    {"label": "Current Status", "key": "current_status"},
  ];

  List<Widget> rows = [];
  for (int i = 0; i < projectDetails.length; i += 3) {
    rows.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (j) {
          final index = i + j;
          if (index >= projectDetails.length) {
            return Expanded(child: Container());
          }
          final item = projectDetails[index];
          final value = details[item["key"]!] ?? "--";
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item["label"]!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    child: Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Project Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    ),
  );
}



Widget _buildSectionType5() {
  if (property == null) return const SizedBox.shrink();

  final tabs = <String, List<String>>{
    "All": [
      //...property!.gallery.map((e) => e["image_url"] ?? ""),
      ...property!.elevationImages,
      ...property!.masterPlans,
      ...property!.floorPlans,
      ...property!.towerPlans,
      ...property!.clubhouseImages,
      ...property!.amenitiesImages,
      //...property!.siteMapImages,
    ],
    if (property!.elevationImages.isNotEmpty) "Elevation Images": property!.elevationImages,
    if (property!.masterPlans.isNotEmpty) "Master Plans": property!.masterPlans,
    if (property!.floorPlans.isNotEmpty) "Floor Plans": property!.floorPlans,
    if (property!.towerPlans.isNotEmpty) "Tower Plans": property!.towerPlans,
    if (property!.clubhouseImages.isNotEmpty) "Clubhouse Images": property!.clubhouseImages,
    if (property!.amenitiesImages.isNotEmpty) "Amenities Images": property!.amenitiesImages,
    //if (property!.siteMapImages.isNotEmpty) "Site Map Images": property!.siteMapImages,
  };

  String selectedTab = "All";

  return StatefulBuilder(
    builder: (context, setState) {
      final imageList = tabs[selectedTab] ?? [];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 16, 15, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Project Gallery",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // 🔘 Tab Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tabs.keys.map((tab) {
                    final isSelected = selectedTab == tab;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTab = tab),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF00796B) : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF00796B)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // 🖼 Horizontal Image List with Fullscreen Preview
              if (imageList.isNotEmpty)
                SizedBox(
                  height: 130,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final imageUrl = imageList[index];

                      return GestureDetector(
                        onTap: () {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black,
    barrierLabel: "Gallery Viewer",
    pageBuilder: (_, __, ___) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // A. Column view
                if (zoomedIndex == null)
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: imageList.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () => setState(() => zoomedIndex = i),
                        child: Hero(
                          tag: 'section5_$i',
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            height: MediaQuery.of(context).size.height * 0.45, // show 2.5 items
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              image: DecorationImage(
                                image: NetworkImage(imageList[i]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )

                // B. Zoom View
                else
                  GestureDetector(
                    onTap: () => setState(() => zoomedIndex = null),
                    child: PhotoView(
                      imageProvider: NetworkImage(imageList[zoomedIndex!]),
                      backgroundDecoration: const BoxDecoration(color: Colors.black),
                      heroAttributes: PhotoViewHeroAttributes(tag: 'section5_$zoomedIndex'),
                    ),
                  ),

                // C. Top Close Button
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (zoomedIndex != null)
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => setState(() => zoomedIndex = null),
                        )
                      else
                        const SizedBox(width: 48), // placeholder

                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
},

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
  imageUrl,
  height: 120,
  width: 160,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    debugPrint("❌ Failed to load: $imageUrl");
    return Container(
      height: 120,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
    );
  },
)

                        ),
                      );
                    },
                  ),
                )
              else
                const Text("No images available for this category."),
            ],
          ),
        ),
      );
    },
  );
}



/// ---------------------------------------------------------------------------
///  Section‑6  :  Configurations list with tap‑to‑open image preview
/// ---------------------------------------------------------------------------
///  * Shows BHK tabs and a horizontal list of configuration cards
///  * Tapping the image opens it full‑screen (with pinch‑to‑zoom) and
///    closes on back button or the on‑screen “X”
/// ---------------------------------------------------------------------------

Widget _buildSectionType6() {
  if (property == null || property!.configurations.isEmpty) {
    return const SizedBox.shrink();
  }

  // ── Unique BHK options ────────────────────────────────────────────────────
  final bhkOptions = property!.configurations
      .map((e) => e['configuration_type'] ?? '--')
      .toSet()
      .toList();

  int selectedBHKIndex = 0;

  return StatefulBuilder(
    builder: (context, setState) {
      final String selectedBHK = bhkOptions[selectedBHKIndex];

      // Filter configurations for the currently selected BHK
      final filteredConfigs = property!.configurations
          .where((c) => c['configuration_type'] == selectedBHK)
          .toList();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configurations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // ── BHK selector chips ───────────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(bhkOptions.length, (index) {
                  final isSelected = selectedBHKIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedBHKIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF008080)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          bhkOptions[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),

            // ── Configuration cards list ────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filteredConfigs.map((config) {
                  final imageUrl = config['image_url'] != null
                      ? '${config['image_url']}'
                      : 'https://via.placeholder.com/200x120.png?text=No+Image';

                  return Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Size | Facing title row ────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                config['size'] ?? '--',
                                style: const TextStyle(
                                  color: primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                '|',
                                style: TextStyle(
                                  color: primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                config['facing'] ?? '--',
                                style: const TextStyle(
                                  color: primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // ── Image with tap‑to‑open full screen ─────────────
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    FullScreenImageView(imageUrl: imageUrl),
                              ),
                            );
                          },
                          child: Hero(
                            tag: imageUrl, // ‑‑ unique tag for Hero transition
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ── Price row ──────────────────────────────────────
                        Row(
                          children: [
                            Text(
                              config['price_label'] ?? '--',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              ' + Other Charges',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    title: const Text('Other Charges'),
                                    content: const Text(
                                      'Please contact the builder for a detailed price sheet.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(Icons.info_outline, size: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // ── Contact Builder button ────────────────────────
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade100,
                            foregroundColor: Colors.blue.shade900,
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => const ContactBuilderDialog(),
                            );
                          },
                          icon: const Icon(Icons.phone, size: 18),
                          label: const Text('Contact Builder'),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}





Widget _buildSectionType7() {
  if (property == null || property!.amenities.isEmpty) {
    return const SizedBox.shrink();
  }

  return StatefulBuilder(
    builder: (context, setState) {
      bool showAll = false;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Amenities",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(builder: (context, constraints) {
                double itemWidth = (constraints.maxWidth - 64) / 3;

                final displayAmenities = showAll
                    ? property!.amenities
                    : property!.amenities.take(9).toList();

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: displayAmenities.map((amenity) {
                    return SizedBox(
                      width: itemWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ icon image if available
                          amenity["icon_url"] != null && amenity["icon_url"]!.isNotEmpty
                              ? Image.network(
                                  "${AppConstants.baseUrl}${amenity["icon_url"]}",
                                  height: 18,
                                  width: 18,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.check, size: 18),
                                )
                              : const Icon(Icons.check, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              amenity["name"] ?? "--",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 10),
              if (property!.amenities.length > 9)
                GestureDetector(
                  onTap: () => setState(() {
                    showAll = !showAll;
                  }),
                  child: Row(
                    children: [
                      Icon(
                        showAll ? Icons.expand_less : Icons.expand_more,
                        color: Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        showAll ? "View Less" : "View More",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
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
  );
}


Widget _buildSectionType8() {
  if (property == null || property!.specifications.isEmpty) {
    return const SizedBox.shrink();
  }

  // split the text from API by newline for bullet points
  final specPoints = property!.specifications
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  bool showAll = false;

  return StatefulBuilder(
    builder: (context, setState) {
      final displaySpecs = showAll ? specPoints : specPoints.take(4).toList();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Material Specifications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: displaySpecs.map((point) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "• ",
                          style: TextStyle(fontSize: 16, height: 1.4),
                        ),
                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              if (specPoints.length > 4)
                GestureDetector(
                  onTap: () => setState(() => showAll = !showAll),
                  child: Row(
                    children: [
                      Icon(
                        showAll ? Icons.expand_less : Icons.expand_more,
                        color: Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        showAll ? "View Less" : "View More",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
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
  );
}


Widget _buildSectionType9() {
  final reviews = property?.reviews ?? [];

  // calculate average
  final avgRating = reviews.isNotEmpty
      ? double.parse(
          (reviews
                      .map((r) => double.tryParse(r["rating"] ?? "0") ?? 0)
                      .reduce((a, b) => a + b) /
                  reviews.length)
              .toStringAsFixed(1),
        )
      : 0.0;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  avgRating.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Fabulous",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen),
              ),
              const SizedBox(width: 6),
              Text(
                "${reviews.length} reviews",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Review Cards
          if (reviews.isNotEmpty)
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name & date row
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 14,
                              backgroundImage:
                                  AssetImage('assets/images/user_avatar.png'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "User", // since no name field in JSON, using static
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    review["date"] ?? "--",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                review["rating"] ?? "0",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Comment
                        Text(
                          review["comment"] ?? "",
                          style: const TextStyle(fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.thumb_up_alt_outlined,
                                size: 16, color: Colors.red),
                            SizedBox(width: 4),
                            Text(
                              "Helpful",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "No reviews yet.",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),

          const SizedBox(height: 8),

          // Read all button
          if (reviews.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllReviewsPage(reviews: reviews),
                    ),
                  );
                },
                child: Text(
                  "Read all ${reviews.length} reviews",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

  
Widget _buildSectionType10() {
  if (property == null || property!.keyHighlights.isEmpty) {
    return const SizedBox.shrink();
  }

  // group highlights by category
  final Map<String, List<Map<String, String>>> highlightsMap = {};
  for (var item in property!.keyHighlights) {
    final category = item["category"] ?? "Other";
    highlightsMap.putIfAbsent(category, () => []);
    highlightsMap[category]!.add(item);
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Key Highlights",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: highlightsMap.entries.map((entry) {
              return Container(
                width: 320,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...entry.value.map((highlight) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle,
                                  size: 16, color: primaryGreen),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "${highlight["title"]} (${highlight["distance"]})",
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}





Widget _buildSectionType11() {
  if (property == null || property!.hotspots.isEmpty) {
    return const SizedBox.shrink();
  }

  // group by category
  final Map<String, List<Map<String, String>>> groupedHotspots = {};
  for (final item in property!.hotspots) {
    final category = item["category"] ?? "Others";
    if (!groupedHotspots.containsKey(category)) {
      groupedHotspots[category] = [];
    }
    groupedHotspots[category]!.add(item);
  }

  String selectedCategory = groupedHotspots.keys.first;

  return StatefulBuilder(
    builder: (context, setState) {
      final items = groupedHotspots[selectedCategory]!;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Location Hotspots",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // Category Toggle Buttons
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: groupedHotspots.keys.map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        selectedColor: primaryGreen,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected
                                ? primaryGreen
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 14),

              // Hotspot Points
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: primaryGreen),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
  "${(item["title"]?.split(',').first.trim() ?? '--')} "
  "(${item["distance"] ?? ''})",
  style: const TextStyle(fontSize: 14, color: Colors.black87),
),

                        )
                      ],
                    ),
                  )),

              const SizedBox(height: 12),

              // View on Map button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.map_outlined, color: Colors.white),
                  label: const Text(
                    "View on Map",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => LocationMapScreen(
      hotspots: property!.hotspots,
      propertyLat: double.tryParse(property!.geoLatitude ?? '') ?? 0.0,
      propertyLng: double.tryParse(property!.geoLongitude ?? '') ?? 0.0,
      geoAddress: property!.geoAddress,
      title: property!.title, // 👈 null fallback
    ),
  ),
);
                  },
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}



Widget _buildSectionType12() {
  if (property == null || property!.loans.isEmpty) {
    return const SizedBox.shrink();
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Home Loans",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: property!.loans.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final loan = property!.loans[index];
              final bankName = loan["bank_name"] ?? "--";
              final bankLogo = loan["bank_logo"] ?? "";
              final interestRate = loan["interest_rate"] ?? "--";

              return Container(
                width: 130,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    bankLogo.isNotEmpty 
                        ? Image.network(
                            bankLogo,
                            height: 32,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.account_balance),
                          )
                        : const Icon(Icons.account_balance),
                    const SizedBox(height: 6),
                    Text(
                      bankName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      interestRate,
                      style: const TextStyle(fontSize: 11, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    ),
  );
}


Widget _buildSectionType13() {
  if (property == null || property!.videos.isEmpty) {
    return const SizedBox.shrink();
  }

  Map<String, List<Map<String, String>>> videosByType = {};

  for (var v in property!.videos) {
    final type = v["type"] ?? "Other";
    if (!videosByType.containsKey(type)) {
      videosByType[type] = [];
    }
    videosByType[type]!.add(v);
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Video Walkthrough",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        // loop each type
        ...videosByType.entries.map((entry) {
          final type = entry.key;
          final videos = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    final url = video["video_url"] ?? "";
                    final title = video["title"] ?? "";
                    bool showWebView = false;

                    return StatefulBuilder(
                      builder: (context, setInnerState) {
                        return Container(
                          width: 300,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: showWebView
                                ? InAppWebView(
                                    initialUrlRequest: URLRequest(url: WebUri(url)),
                                    initialOptions: InAppWebViewGroupOptions(
                                      crossPlatform: InAppWebViewOptions(
                                        mediaPlaybackRequiresUserGesture: false,
                                      ),
                                    ),
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/video_placeholder.jpg",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                      Container(
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                      GestureDetector(
                                        onTap: () => setInnerState(() => showWebView = true),
                                        child: const Icon(Icons.play_circle_fill,
                                            size: 64, color: Colors.white),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        right: 8,
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ],
    ),
  );
}


Widget _buildSectionType14(BuildContext context) {
  final brochureUrl = property?.brochureUrl ?? '';

  if (brochureUrl.isEmpty) return const SizedBox.shrink();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Brochure",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        // 📄 Brochure Preview
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PDFViewPage(
                  pdfUrl: "${AppConstants.baseUrl}$brochureUrl",
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/brochure_preview.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 🧾 Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.phone, color: Colors.white),
                label: const Text("Contact Builder", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // ☎️ Add your contact builder logic
                },
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.share, color: Colors.white),
              label: const Text("Share", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final url = "${AppConstants.baseUrl}$brochureUrl";
                Share.share("Check out this brochure: $url");
              },
            ),
          ],
        ),
      ],
    ),
  );
}



// Widget _buildSectionType15(BuildContext context) {
//   List<Map<String, dynamic>> lifestyleProperties = [
//     {
//       "image": "assets/images/property1.jpg",
//       "title": "Primark Eco Nest",
//       "builder": "By Primark Infra",
//       "location": "Kompally",
//       "propertyType": "2 & 3 BHK",
//       "priceRange": "₹ 55.7 L - ₹ 1.04 Cr",
//       "availability": "Ready by Dec 2025",
//       "brandLogo": "assets/images/elite_logo.jpg",
//     },
//     {
//       "image": "assets/images/property2.jpg",
//       "title": "Sky View Residences",
//       "builder": "By Skyline Developers",
//       "location": "Madhapur",
//       "propertyType": "3 & 4 BHK",
//       "priceRange": "₹ 1.20 Cr - ₹ 2.50 Cr",
//       "availability": "Possession in 2026",
//       "brandLogo": "assets/images/elite_logo.jpg",
//     },
//     {
//       "image": "assets/images/property3.jpg",
//       "title": "Elite Grandeur",
//       "builder": "By Elite Constructions",
//       "location": "Gachibowli",
//       "propertyType": "2 & 3 BHK",
//       "priceRange": "₹ 95.0 L - ₹ 2.20 Cr",
//       "availability": "Under Construction",
//       "brandLogo": "assets/images/elite_logo.jpg",
//     },
//   ];

//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Similar Properties",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: MediaQuery.of(context).size.width * 0.8,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: lifestyleProperties.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 10),
//             itemBuilder: (context, index) {
//               return _buildSection15ItemLayout(context, lifestyleProperties[index]);
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildSection15ItemLayout(BuildContext context, Map<String, dynamic> property) {
//   double screenWidth = MediaQuery.of(context).size.width;
//   double imageHeight = screenWidth * 0.5;

//   return Stack(
//     clipBehavior: Clip.none,
//     children: [
//       Container(
//         width: 280,
//         margin: const EdgeInsets.fromLTRB(10, 5, 5, 0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.grey.shade300, width: 1.5),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             // 🖼 Image Section
//             Stack(
//               children: [
//                 Container(
//                   height: imageHeight,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     image: DecorationImage(
//                       image: AssetImage(property["image"]!),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.grey, width: 1.5),
//                       color: Colors.white,
//                     ),
//                     child: const CircleAvatar(
//                       radius: 16,
//                       backgroundColor: Colors.white,
//                       child: Icon(Icons.favorite_border, color: Colors.red),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // 📋 Details Section
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 18,
//                         backgroundImage: AssetImage(property["brandLogo"]!),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               property["title"]!,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 3),
//                             Text(
//                               property["builder"]!,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black54,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // 👈 Left Column
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   const Icon(Icons.location_on,
//                                       color: Color.fromARGB(255, 8, 123, 123),
//                                       size: 16),
//                                   const SizedBox(width: 5),
//                                   Expanded(
//                                     child: Text(
//                                       property["location"]!,
//                                       style: const TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.king_bed,
//                                       color: Color.fromARGB(255, 8, 123, 123),
//                                       size: 16),
//                                   const SizedBox(width: 5),
//                                   Expanded(
//                                     child: Text(
//                                       property["propertyType"]!,
//                                       style: const TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 👉 Right Column
//                       Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               property["priceRange"]!,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               property["availability"]!,
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 color: Colors.black54,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }



// Widget _buildSectionType16(BuildContext context) {
//   List<Map<String, dynamic>> lifestyleProperties = [
//     {
//       "image": "assets/images/property1.jpg",
//       "title": "Primark Eco Nest",
//       "builder": "By Primark Infra",
//       "location": "Kompally",
//       "propertyType": "2 & 3 BHK",
//       "priceRange": "₹ 55.7 L - ₹ 1.04 Cr",
//       "availability": "Ready by Dec 2025",
//       "brandLogo": "assets/images/elite_logo.jpg",
//     },
//     {
//       "image": "assets/images/property2.jpg",
//       "title": "Sky View Residences",
//       "builder": "By Skyline Developers",
//       "location": "Madhapur",
//       "propertyType": "3 & 4 BHK",
//       "priceRange": "₹ 1.20 Cr - ₹ 2.50 Cr",
//       "availability": "Possession in 2026",
//       "brandLogo": "assets/images/elite_logo.jpg",
//     },
//     {
//       "image": "assets/images/property3.jpg",
//       "title": "Elite Grandeur",
//       "builder": "By Elite Constructions",
//       "location": "Gachibowli",
//       "propertyType": "2 & 3 BHK",
//       "priceRange": "₹ 95.0 L - ₹ 2.20 Cr",
//       "availability": "Under Construction",
//       "brandLogo": "assets/images/elite_logo.jpg",
//     },
//   ];

//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Recommended Villas",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: MediaQuery.of(context).size.width * 0.7,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: lifestyleProperties.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 10),
//             itemBuilder: (context, index) {
//               return _buildSection16ItemLayout(context, lifestyleProperties[index]);
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildSection16ItemLayout(BuildContext context, Map<String, dynamic> property) {
//   double screenWidth = MediaQuery.of(context).size.width;
//   double imageHeight = screenWidth * 0.4;

//   return Stack(
//     clipBehavior: Clip.none,
//     children: [
//       Container(
//         width: 280,
//         margin: const EdgeInsets.fromLTRB(10, 5, 5, 0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.grey.shade300, width: 1.5),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             // 🖼 Image Section
//             Stack(
//               children: [
//                 Container(
//                   height: imageHeight,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
//                     image: DecorationImage(
//                       image: AssetImage(property["image"]!),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.grey, width: 1.5),
//                       color: Colors.white,
//                     ),
//                     child: const CircleAvatar(
//                       radius: 16,
//                       backgroundColor: Colors.white,
//                       child: Icon(Icons.favorite_border, color: Colors.red),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // 📋 Details Section
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 18,
//                         backgroundImage: AssetImage(property["brandLogo"]!),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               property["title"]!,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 3),
//                             Text(
//                               property["builder"]!,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black54,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // 👈 Left Column
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   const Icon(Icons.location_on,
//                                       color: Color.fromARGB(255, 8, 123, 123),
//                                       size: 16),
//                                   const SizedBox(width: 5),
//                                   Expanded(
//                                     child: Text(
//                                       property["location"]!,
//                                       style: const TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.king_bed,
//                                       color: Color.fromARGB(255, 8, 123, 123),
//                                       size: 16),
//                                   const SizedBox(width: 5),
//                                   Expanded(
//                                     child: Text(
//                                       property["propertyType"]!,
//                                       style: const TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // 👉 Right Column
//                       Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               property["priceRange"]!,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               property["availability"]!,
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 color: Colors.black54,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildSectionType17(BuildContext context) {
//   final double screenHeight = MediaQuery.of(context).size.height;
//   final double sectionHeight = screenHeight * 0.37; // 55% of screen height

//   List<Map<String, dynamic>> shortlistedProperties = [
//     {
//       "image": "assets/images/property1.jpg",
//       "title": "Aliens Space Station",
//       "builder": "Aparna Constructions",
//       "availability": "Ready by Sep 2024",
//       "location": "Tellapur",
//       "bhk": "2, 3, 4, 5 BHK",
//       "price": "₹ 96 L - ₹ 2.50 Cr",
//     },
//     {
//       "image": "assets/images/property2.jpg",
//       "title": "Aliens Space Station",
//       "builder": "Aparna Constructions",
//       "availability": "Ready by Sep 2024",
//       "location": "Tellapur",
//       "bhk": "2, 3, 4, 5 BHK",
//       "price": "₹ 96 L - ₹ 2.50 Cr",
//     },
//     {
//       "image": "assets/images/property3.jpg",
//       "title": "Aliens Space Station",
//       "builder": "Aparna Constructions",
//       "availability": "Ready by Sep 2024",
//       "location": "Tellapur",
//       "bhk": "2, 3, 4, 5 BHK",
//       "price": "₹ 96 L - ₹ 2.50 Cr",
//     },
//     {
//       "image": "assets/images/property4.jpg",
//       "title": "Aliens Space Station",
//       "builder": "Aparna Constructions",
//       "availability": "Ready by Sep 2024",
//       "location": "Tellapur",
//       "bhk": "2, 3, 4, 5 BHK",
//       "price": "₹ 96 L - ₹ 2.50 Cr",
//     },
//   ];

//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Shortlisted by most users",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: sectionHeight, // 🔁 Responsive height based on screen
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: shortlistedProperties.length,
//             itemBuilder: (context, index) {
//               final property = shortlistedProperties[index];
//               return _buildShortlistCard(context, property);
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }


// Widget _buildShortlistCard(BuildContext context, Map<String, dynamic> property) {
//   double screenWidth = MediaQuery.of(context).size.width;
//   double cardWidth = screenWidth * 0.78; // ~78% of screen width
//   double imageHeight = screenWidth * 0.5; // ~50% of screen height for image

//   return Container(
//     width: cardWidth,
//     margin: const EdgeInsets.only(right: 12),
//     padding: const EdgeInsets.all(3),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(15),
//       // boxShadow: [
//       //   BoxShadow(
//       //     color: Colors.grey.withOpacity(0.2),
//       //     blurRadius: 5,
//       //     spreadRadius: 2,
//       //   ),
//       // ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ✅ Property Image with Favorite Button
//         ClipRRect(
//           borderRadius: BorderRadius.circular(15),
//           child: Stack(
//             children: [
//               Image.asset(
//                 property["image"]!,
//                 width: double.infinity,
//                 height: imageHeight,
//                 fit: BoxFit.cover,
//               ),
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: const CircleAvatar(
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.favorite_border, color: Colors.red),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),

//         // ✅ Title + Builder + Availability
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.grey[300],
//               child: const Icon(Icons.apartment, color: Colors.grey),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     property["title"]!,
//                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "By ${property["builder"]}",
//                         style: const TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                       const Text("  |  "),
//                       Text(
//                         property["availability"]!,
//                         style: const TextStyle(fontSize: 12, color: primaryGreen),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 5),

//         // ✅ Location & BHK Row
//         Padding(
//           padding: const EdgeInsets.only(left: 70),
//           child: Row(
//             children: [
//               const Icon(Icons.location_on, color: primaryGreen, size: 18),
//               const SizedBox(width: 5),
//               Text(
//                 property["location"]!,
//                 style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(width: 15),
//               const Icon(Icons.king_bed, color: primaryGreen, size: 18),
//               const SizedBox(width: 5),
//               Text(
//                 property["bhk"]!,
//                 style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),

//         // ✅ Price + Compare + Call Buttons
//         Padding(
//           padding: const EdgeInsets.only(left: 20),
//           child: Row(
//             children: [
//               // 💰 Price Button
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: screenWidth * 0.05,
//                   vertical: screenWidth * 0.025,
//                 ),
//                 decoration: BoxDecoration(
//                   color: primaryGreen,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   property["price"]!,
//                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(width: screenWidth * 0.1),

//               // 🔁 Compare Button
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: EdgeInsets.all(screenWidth * 0.025),
//                 child: const Icon(Icons.compare_arrows, color: Colors.black, size: 22),
//               ),
//               const SizedBox(width: 10),

//               // ☎️ Call Button
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: EdgeInsets.all(screenWidth * 0.025),
//                 child: const Icon(Icons.phone, color: Colors.white, size: 22),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }



// Widget _buildSectionType18(BuildContext context) {
//   final List<String> locations = ["Tellapur", "Kollur", "Gachibowli", "Gopanpalle"];

//   final Map<String, List<Map<String, dynamic>>> propertiesByLocation = {
//     "Tellapur": [
//       {
//         "image": "assets/images/property1.jpg",
//         "title": "Vaishnavi Houdini",
//         "builder": "Vaishnavi Infracon India Pvt Ltd",
//         "availability": "Ready by Sep 2025",
//         "location": "Bandlaguda Jagir",
//         "bhk": "2 BHK villa",
//         "price": "₹ 96.0 L - ₹ 2.50 Cr",
//       },
//       {
//         "image": "assets/images/property2.jpg",
//         "title": "Marbella Greens",
//         "builder": "Villascape Developers",
//         "availability": "Possession in 2026",
//         "location": "Tellapur",
//         "bhk": "3, 4 BHK",
//         "price": "₹ 1.50 Cr - ₹ 3.25 Cr",
//       },
//     ],
//     "Kollur": [
//       {
//         "image": "assets/images/property3.jpg",
//         "title": "Kollur Heights",
//         "builder": "Vision Infra",
//         "availability": "Ready by Dec 2025",
//         "location": "Kollur",
//         "bhk": "3 BHK",
//         "price": "₹ 85.0 L - ₹ 1.75 Cr",
//       }
//     ],
//     "Gachibowli": [
//       {
//         "image": "assets/images/property4.jpg",
//         "title": "Gachibowli Heights",
//         "builder": "Vision Infra",
//         "availability": "Ready by Dec 2025",
//         "location": "Kollur",
//         "bhk": "3 BHK",
//         "price": "₹ 85.0 L - ₹ 1.75 Cr",
//       }
//     ],
//     "Gopanpalle": [
//       {
//         "image": "assets/images/property5.jpg",
//         "title": "Gopanpalle Heights",
//         "builder": "Vision Infra",
//         "availability": "Ready by Dec 2025",
//         "location": "Kollur",
//         "bhk": "3 BHK",
//         "price": "₹ 85.0 L - ₹ 1.75 Cr",
//       }
//     ],
//     // Add more dummy entries for Gachibowli and Gopanpalle if needed
//   };

//   String selectedLocation = "Tellapur";

//   return StatefulBuilder(
//     builder: (context, setState) {
//       final List<Map<String, dynamic>> properties = propertiesByLocation[selectedLocation] ?? [];

//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Explore villas near $selectedLocation",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             // Toggle Buttons
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: locations.map((location) {
//                   final bool isSelected = location == selectedLocation;
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: ChoiceChip(
//                       label: Text(location),
//                       selected: isSelected,
//                       onSelected: (_) => setState(() => selectedLocation = location),
//                       selectedColor: primaryGreen,
//                       backgroundColor: Colors.white,
//                       labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(
//                           color: isSelected ? primaryGreen : Colors.grey.shade400,
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             const SizedBox(height: 5),
//             // Properties List
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.36 ,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: properties.length,
//                 itemBuilder: (context, index) {
//                   final property = properties[index];
//                   return Container(
//                     width: MediaQuery.of(context).size.width * 0.64,
//                     margin: const EdgeInsets.only(right: 12, top: 5),
//                     padding: const EdgeInsets.all(3),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15),
//                       // boxShadow: [
//                       //   BoxShadow(
//                       //     color: Colors.grey.withOpacity(0.2),
//                       //     blurRadius: 5,
//                       //     spreadRadius: 2,
//                       //   ),
//                       // ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: Stack(
//                             children: [
//                               Image.asset(
//                                 property["image"]!,
//                                 width: double.infinity,
//                                 height: MediaQuery.of(context).size.height * 0.2,
//                                 fit: BoxFit.cover,
//                               ),
//                               const Positioned(
//                                 top: 10,
//                                 right: 10,
//                                 child: CircleAvatar(
//                                   backgroundColor: Colors.white,
//                                   child: Icon(Icons.favorite_border, color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 property["title"]!,
//                                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "By ${property["builder"]}",
//                                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//                               ),
//                               Text(
//                                 property["availability"]!,
//                                 style: const TextStyle(fontSize: 12, color: primaryGreen),
//                               ),
//                               const SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.location_on, color: primaryGreen, size: 18),
//                                   const SizedBox(width: 5),
//                                   Text(
//                                     property["location"]!,
//                                     style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   const Icon(Icons.king_bed, color: primaryGreen, size: 18),
//                                   const SizedBox(width: 5),
//                                   Text(
//                                     property["bhk"]!,
//                                     style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                     decoration: BoxDecoration(
//                                       color: primaryGreen,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Text(
//                                       property["price"]!,
//                                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey.shade300,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     padding: const EdgeInsets.all(8),
//                                     child: const Icon(Icons.compare_arrows, size: 18),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     padding: const EdgeInsets.all(8),
//                                     child: const Icon(Icons.phone, size: 18, color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }


// Widget _buildSectionType19(BuildContext context) {
//   final double screenHeight = MediaQuery.of(context).size.height;
//   final double sectionHeight = screenHeight * 0.37; // 55% of screen height

//   List<Map<String, dynamic>> shortlistedProperties = [
//     {
//       "image": "assets/images/property1.jpg",
//       "title": "Aliens Space Station",
//       "builder": "Aparna Constructions",
//       "availability": "Ready by Sep 2024",
//       "location": "Tellapur",
//       "bhk": "2, 3, 4, 5 BHK",
//       "price": "₹ 96 L - ₹ 2.50 Cr",
//     },
//     {
//       "image": "assets/images/property2.jpg",
//       "title": "Aliens Space Station",
//       "builder": "Aparna Constructions",
//       "availability": "Ready by Sep 2024",
//       "location": "Tellapur",
//       "bhk": "2, 3, 4, 5 BHK",
//       "price": "₹ 96 L - ₹ 2.50 Cr",
//     },
//     {
//       "image": "assets/images/property3.jpg",
//       "title": "Aliens Space Station",
//       "builder": "Aparna Constructions",
//       "availability": "Ready by Sep 2024",
//       "location": "Tellapur",
//       "bhk": "2, 3, 4, 5 BHK",
//       "price": "₹ 96 L - ₹ 2.50 Cr",
//     },
//     {
//       "image": "assets/images/property4.jpg",
//       "title": "Aliens Space Station",
//       "builder": "Aparna Constructions",
//       "availability": "Ready by Sep 2024",
//       "location": "Tellapur",
//       "bhk": "2, 3, 4, 5 BHK",
//       "price": "₹ 96 L - ₹ 2.50 Cr",
//     },
//   ];

//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Shortlisted by most users",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: sectionHeight, // 🔁 Responsive height based on screen
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: shortlistedProperties.length,
//             itemBuilder: (context, index) {
//               final property = shortlistedProperties[index];
//               return _buildRecentCard(context, property);
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }


// Widget _buildRecentCard(BuildContext context, Map<String, dynamic> property) {
//   double screenWidth = MediaQuery.of(context).size.width;
//   double cardWidth = screenWidth * 0.78; // ~78% of screen width
//   double imageHeight = screenWidth * 0.5; // ~50% of screen height for image

//   return Container(
//     width: cardWidth,
//     margin: const EdgeInsets.only(right: 12),
//     padding: const EdgeInsets.all(3),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(15),
//       // boxShadow: [
//       //   BoxShadow(
//       //     color: Colors.grey.withOpacity(0.2),
//       //     blurRadius: 5,
//       //     spreadRadius: 2,
//       //   ),
//       // ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ✅ Property Image with Favorite Button
//         ClipRRect(
//           borderRadius: BorderRadius.circular(15),
//           child: Stack(
//             children: [
//               Image.asset(
//                 property["image"]!,
//                 width: double.infinity,
//                 height: imageHeight,
//                 fit: BoxFit.cover,
//               ),
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: const CircleAvatar(
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.favorite_border, color: Colors.red),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),

//         // ✅ Title + Builder + Availability
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.grey[300],
//               child: const Icon(Icons.apartment, color: Colors.grey),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     property["title"]!,
//                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "By ${property["builder"]}",
//                         style: const TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                       const Text("  |  "),
//                       Text(
//                         property["availability"]!,
//                         style: const TextStyle(fontSize: 12, color: primaryGreen),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 5),

//         // ✅ Location & BHK Row
//         Padding(
//           padding: const EdgeInsets.only(left: 70),
//           child: Row(
//             children: [
//               const Icon(Icons.location_on, color: primaryGreen, size: 18),
//               const SizedBox(width: 5),
//               Text(
//                 property["location"]!,
//                 style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(width: 15),
//               const Icon(Icons.king_bed, color: primaryGreen, size: 18),
//               const SizedBox(width: 5),
//               Text(
//                 property["bhk"]!,
//                 style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),

//         // ✅ Price + Compare + Call Buttons
//         Padding(
//           padding: const EdgeInsets.only(left: 20),
//           child: Row(
//             children: [
//               // 💰 Price Button
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: screenWidth * 0.05,
//                   vertical: screenWidth * 0.025,
//                 ),
//                 decoration: BoxDecoration(
//                   color: primaryGreen,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   property["price"]!,
//                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(width: screenWidth * 0.1),

//               // 🔁 Compare Button
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: EdgeInsets.all(screenWidth * 0.025),
//                 child: const Icon(Icons.compare_arrows, color: Colors.black, size: 22),
//               ),
//               const SizedBox(width: 10),

//               // ☎️ Call Button
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: EdgeInsets.all(screenWidth * 0.025),
//                 child: const Icon(Icons.phone, color: Colors.white, size: 22),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget _buildSectionType20(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardWidth = screenWidth * 0.30;
  double cardHeight = screenWidth * 0.13;

  return FutureBuilder<List<dynamic>>(
    future: fetchProjectData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: Text("Error loading projects")),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: Text("No projects available")),
        );
      }

      final data = snapshot.data!;
      final Map<String, int> localityCounts = {};

      for (var item in data) {
        final address = item['project']?['geo_address'] ?? '';
        if (address.isNotEmpty) {
          final parts = address.split(',');
          final trimmedParts = parts.map((e) => e.trim()).toList();
          String locality = '';

          if (trimmedParts.length >= 4) {
            locality = trimmedParts[trimmedParts.length - 4];
          } else if (trimmedParts.length >= 3) {
            locality = trimmedParts[trimmedParts.length - 3];
          } else {
            locality = 'Unknown';
          }

          if (locality.isNotEmpty) {
            localityCounts[locality] = (localityCounts[locality] ?? 0) + 1;
          }
        }
      }

      final List<Map<String, String>> projectCategories = localityCounts.entries.map((entry) {
        return {
          'name': entry.key,
          'projects': "${entry.value} Project${entry.value > 1 ? 's' : ''}",
        };
      }).toList();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Explore Projects in Other Locations",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: cardHeight * 3 + 24,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    (projectCategories.length / 3).ceil(),
                    (columnIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          children: List.generate(3, (rowIndex) {
                            int itemIndex = columnIndex * 3 + rowIndex;
                            if (itemIndex >= projectCategories.length) {
                              return const SizedBox.shrink();
                            }

                            final category = projectCategories[itemIndex];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NavigationScreen(
                                      selectedIndex: 1,
                                      initialPageType: category['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                width: cardWidth,
                                height: cardHeight,
                                child: _buildlocationCard(category),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}



// Category Card Widget
Widget _buildlocationCard(Map<String, String> category) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: const DecorationImage(
        image: AssetImage("assets/images/hyderabad_bg.jpg"),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black.withOpacity(0.4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category["name"]!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              category["projects"]!,
              style: const TextStyle(color: Colors.white, fontSize: 11.5),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}



Widget _buildSectionType21(BuildContext context) {
  List<Map<String, dynamic>> supportItems = [
    {
      "icon": "assets/images/emi.jpg",
      "title": "EMI\nCalculator",
       "backgroundColor": Color.fromARGB(255, 115, 202, 229),
    },
    {
      "icon": "assets/images/assistance.jpg",
      "title": "Get property assistance from proser",
       "backgroundColor": Color.fromARGB(255, 176, 229, 115),
    },
    {
      "icon": "assets/images/policy.jpg",
      "title": "Policy & Legal Guide",
       "backgroundColor": Colors.black12,
    },
  ];

  double cardWidth = MediaQuery.of(context).size.width / 2.4;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Help and Support",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: supportItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = supportItems[index];
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => const MortgageCalculatorSheet(),
                    );
                  }
                },
child: Container(
  width: cardWidth,
  decoration: BoxDecoration(
    color: item["backgroundColor"] ?? Colors.white,  // <-- Changed here
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: Colors.grey.shade200),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Top content (title + button)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item["title"] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
            ),
          ],
        ),
      ),

      const Spacer(),

      // Image fixed at bottom
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(80),
        ),
        child: Image.asset(
          item["icon"] ?? '',
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    ],
  ),
),


              );
            },
          ),
        ),
      ],
    ),
  );
}


}

class MortgageCalculatorSheet extends StatefulWidget {
  const MortgageCalculatorSheet({Key? key}) : super(key: key);

  @override
  State<MortgageCalculatorSheet> createState() => _MortgageCalculatorSheetState();
}

class _MortgageCalculatorSheetState extends State<MortgageCalculatorSheet> {
  double downPayment = 10000000;
  double tenure = 15;
  double interestRate = 10;
  double totalAmount = 25000000;
  bool showResult = false;

  @override
  Widget build(BuildContext context) {
    double monthlyEMI = _calculateEMI();
    double payableInterest = (monthlyEMI * tenure * 12) - (totalAmount - downPayment);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: showResult ? _buildResultView(monthlyEMI, payableInterest) : _buildInputView(),
      ),
    );
  }

  Widget _buildInputView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Mortgage Calculator", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Principle Amount: ₹2,50,00,000", style: TextStyle(color: primaryGreen, fontSize: 16)),
        const SizedBox(height: 10),

        // Down Payment
        _buildSliderCard("DOWN PAYMENT", downPayment, 500000, 25000000, (val) {
          setState(() => downPayment = val);
        }),

        const SizedBox(height: 3),

        // Tenure
        _buildSliderCard("TENURE", tenure, 1, 30, (val) {
          setState(() => tenure = val);
        }, unit: "Yrs"),

        const SizedBox(height: 7),

        // Interest
        _buildSliderCard("Rate of interest (p.a)", interestRate, 0, 26, (val) {
          setState(() => interestRate = val);
        }, unit: "%"),

        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: () => setState(() => showResult = true),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
  "CALCULATE MORTGAGE",
  style: TextStyle(
    color: Colors.white, // ✅ Set text color to white
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
),

        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSliderCard(String title, double value, double min, double max, Function(double) onChanged, {String unit = ""}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${unit.isNotEmpty ? value.toStringAsFixed(0) + unit : '₹${_formatAmount(value)}'}",
                style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            activeColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(double emi, double interest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Total Amount", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("₹${_formatAmount(totalAmount)}", style: const TextStyle(fontSize: 24, color: Colors.black)),
        const SizedBox(height: 20),

        _buildBreakdownRow("Principal Amount", totalAmount - downPayment),
        _buildBreakdownRow("Payable Interest", interest),
        _buildBreakdownRow("Down payment", downPayment),
        _buildBreakdownRow("Monthly EMI", emi),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => setState(() => showResult = false),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            minimumSize: const Size.fromHeight(45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
  "RESET",
  style: TextStyle(
    color: Colors.white, // ✅ Set text color to white
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
),

        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text("₹${_formatAmount(value)}", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  double _calculateEMI() {
    double loanAmount = totalAmount - downPayment;
    double monthlyRate = interestRate / (12 * 100);
    int months = (tenure * 12).toInt();
    return loanAmount * monthlyRate * pow((1 + monthlyRate), months) /
        (pow((1 + monthlyRate), months) - 1);
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{2})+(?!\d))'), (match) => ",");
  }
}



class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: "$title\n",
          style:
              const TextStyle(color: Colors.white70, fontSize: 13, height: 1.2),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
