import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../services/supabase_service.dart';
import 'dart:typed_data';
import 'dart:convert';

class FormPage extends StatefulWidget {
  final Map<String, dynamic>? barangLama;

  const FormPage({super.key, this.barangLama});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();

  final SupabaseService supabaseService = SupabaseService();

  String kondisi = "Grade A (Mint)";
  String kategori = "Tas";

  Uint8List? selectedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.barangLama != null) {
      namaController.text = widget.barangLama!["nama"];
      hargaController.text = widget.barangLama!["harga"].toString();
      kondisi = widget.barangLama!["kondisi"];
      kategori = widget.barangLama!["kategori"];
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        selectedImage = bytes;
      });
    }
  }

  Future<void> simpanData() async {
    if (namaController.text.isEmpty || hargaController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Isi semua data dulu")));
      return;
    }

    int harga = int.tryParse(hargaController.text) ?? 0;

    if (harga <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Harga harus lebih dari 0")));
      return;
    }

    try {
      final barang = {
        "nama": namaController.text,
        "harga": harga,
        "kondisi": kondisi,
        "kategori": kategori,
        "is_sold": widget.barangLama?["is_sold"] ?? false,
        "sold_date": widget.barangLama?["sold_date"],
        "image_path": selectedImage != null
            ? base64Encode(selectedImage!)
            : null,
      };

      debugPrint("DATA YANG DIKIRIM KE SUPABASE:");
      debugPrint(barang.toString());

      if (widget.barangLama == null) {
        await supabaseService.addItem(barang);
      } else {
        await supabaseService.updateItem(widget.barangLama!["id"], barang);
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      debugPrint("ERROR SUPABASE:");
      debugPrint(e.toString());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan data")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.barangLama == null ? "Tambah Barang" : "Edit Barang",
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: selectedImage != null
                    ? Image.memory(selectedImage!, fit: BoxFit.cover)
                    : Center(
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Upload Foto",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            buildLabel("Nama Barang"),
            const SizedBox(height: 6),
            buildTextField(namaController),

            const SizedBox(height: 20),

            buildLabel("Harga Jual"),
            const SizedBox(height: 6),
            buildNumberField(hargaController),

            const SizedBox(height: 20),

            buildLabel("Kondisi"),
            const SizedBox(height: 6),
            buildDropdown(
              value: kondisi,
              items: const [
                "Grade A (Mint)",
                "Grade B (VGC)",
                "Grade C (Fair)",
              ],
              onChanged: (value) {
                setState(() {
                  kondisi = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            buildLabel("Kategori"),
            const SizedBox(height: 6),
            buildDropdown(
              value: kategori,
              items: const ["Tas", "Atasan", "Bawahan", "Sepatu", "Aksesoris"],
              onChanged: (value) {
                setState(() {
                  kategori = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: simpanData,
                child: Text(
                  widget.barangLama == null ? "Simpan" : "Update",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildNumberField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
