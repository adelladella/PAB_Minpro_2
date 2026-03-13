import 'package:flutter/material.dart';
import 'form_page.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../services/supabase_service.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/theme_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "Semua";

  final SupabaseService supabaseService = SupabaseService();
  List items = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    setState(() {
      isLoading = true;
    });

    final data = await supabaseService.getItems();

    setState(() {
      items = data;
      isLoading = false;
    });
  }

  Future<void> hapusBarang(String id) async {
    await supabaseService.deleteItem(id);
    fetchItems();
  }

  Future<void> konfirmasiHapus(String id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Barang"),
        content: const Text("Yakin ingin menghapus barang ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      hapusBarang(id);
    }
  }

  Future<void> ubahStatusBarang(Map item) async {
    if (item["is_sold"] == true) {
      return;
    }

    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Ubah keterangan menjadi terjual?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ya"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await supabaseService.updateItem(item["id"], {
        "is_sold": true,
        "sold_date": DateTime.now().toIso8601String(),
      });

      fetchItems();
    }
  }

  String formatRupiah(String angka) {
    int value = int.tryParse(angka) ?? 0;

    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return formatCurrency.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    List filteredItems = selectedCategory == "Semua"
        ? items
        : items.where((item) => item["kategori"] == selectedCategory).toList();
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.email?.split('@').first ?? 'User';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "theme",
                        child: Text("Toggle Theme"),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == "theme") {
                        themeController.toggleTheme();
                      }
                    },
                  ),
                  Text(
                    "PreLove Notes",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () async {
                      await supabaseService.supabase.auth.signOut();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Text(
                "Welcome, $name ✦",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Text(
                    "Kelola barang preloved kamu hari ini ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),

                  Icon(
                    Icons.favorite,
                    size: 16,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    categoryChip("Semua"),
                    categoryChip("Tas"),
                    categoryChip("Atasan"),
                    categoryChip("Bawahan"),
                    categoryChip("Sepatu"),
                    categoryChip("Aksesoris"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredItems.isEmpty
                    ? Center(
                        child: Text(
                          "Belum ada barang",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(12),

                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.brown.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),

                            child: Row(
                              children: [
                                item["image_path"] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.memory(
                                          base64Decode(item["image_path"]),
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          gaplessPlayback: true,
                                        ),
                                      )
                                    : Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.image,
                                          color: Theme.of(
                                            context,
                                          ).iconTheme.color,
                                        ),
                                      ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["nama"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        formatRupiah(item["harga"].toString()),
                                      ),

                                      Text("Kondisi: ${item["kondisi"]}"),
                                    ],
                                  ),
                                ),

                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        ubahStatusBarang(item);
                                      },
                                      child: item["is_sold"] == true
                                          ? Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(
                                                      context,
                                                    ).cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "SOLD",
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFF8B6B4F,
                                                      ),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 6),

                                                Text(
                                                  item["sold_date"] != null
                                                      ? "• ${DateFormat("dd MMM yyyy").format(DateTime.parse(item["sold_date"]))}"
                                                      : "",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.color,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                "Available",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium?.color,
                                                ),
                                              ),
                                            ),
                                    ),

                                    const SizedBox(height: 6),

                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                FormPage(barangLama: item),
                                          ),
                                        ).then((_) {
                                          fetchItems();
                                        });
                                      },
                                    ),

                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 18),
                                      onPressed: () {
                                        konfirmasiHapus(item["id"]);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B6B4F),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPage()),
          ).then((_) {
            fetchItems();
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget categoryChip(String text) {
    bool isSelected = selectedCategory == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
        });
      },

      child: Container(
        margin: const EdgeInsets.only(right: 10),

        padding: const EdgeInsets.symmetric(horizontal: 16),

        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B6B4F)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF5C4033),
            ),
          ),
        ),
      ),
    );
  }
}
