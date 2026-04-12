import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:contrapp/common_tiles/custom_form_field.dart';
import 'package:contrapp/common_tiles/super_title.dart';
import 'package:contrapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContractorAddressPicker extends StatefulWidget {
  const ContractorAddressPicker({super.key});

  @override
  State<ContractorAddressPicker> createState() =>
      _ContractorAddressPickerState();
}

class _ContractorAddressPickerState extends State<ContractorAddressPicker> {
  final MenuController _menuController = MenuController();

  static const double _menuEntryHeight = 60;
  static const double _menuFooterHeight = 56;

  String get _selectedAddress {
    return normalizeContractorAddress(
      variablesContrat['adressePrestataire']?.toString() ?? '',
    );
  }

  List<String> get _addresses => List<String>.from(contractorAddresses);

  double get _menuVerticalOffset {
    final int rows = _addresses.isEmpty ? 1 : _addresses.length;
    return rows * _menuEntryHeight + _menuFooterHeight + 12;
  }

  @override
  Widget build(BuildContext context) {
    final selectedAddress = _selectedAddress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenuAnchor(
          controller: _menuController,
          style: MenuStyle(
            backgroundColor: WidgetStatePropertyAll<Color?>(Colors.red[50]),
            surfaceTintColor:
                const WidgetStatePropertyAll<Color?>(Colors.transparent),
            side: WidgetStatePropertyAll<BorderSide?>(
              BorderSide(color: Colors.red[200]!),
            ),
            shape: WidgetStatePropertyAll<OutlinedBorder?>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            alignment: AlignmentDirectional.bottomStart,
          ),
          alignmentOffset: Offset(0, -_menuVerticalOffset),
          menuChildren: _buildMenuChildren(selectedAddress),
          builder: (context, controller, child) {
            return InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Container(
                height: 90,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.red[100]!.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.store,
                      color: Colors.red[900],
                      size: 40,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Adresse utilisée',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[600],
                            ),
                          ),
                          Text(
                            selectedAddress.isEmpty
                                ? 'Choisir une adresse'
                                : selectedAddress,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      controller.isOpen
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.red[900],
                      size: 40,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildMenuChildren(String selectedAddress) {
    final addresses = _addresses;
    final menuChildren = <Widget>[];

    if (addresses.isEmpty) {
      menuChildren.add(
        SizedBox(
          // width: 520,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Aucune adresse enregistrée',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
          ),
        ),
      );
    } else {
      for (final address in addresses) {
        menuChildren.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            // width: 520,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectAddress(address),
                    style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),                      
                    child: Row(
                      children: [
                        Icon(
                          selectedAddress == address
                              ? Icons.check
                              : Icons.location_on_outlined,
                          size: 18,
                          color: Colors.red[900],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => _confirmRemoveContractorAddress(address),
                      child: const Icon(Icons.delete, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    menuChildren.add(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Divider(height: 1),
      ),
    );
    menuChildren.add(
      SizedBox(
        width: 520,
        child: TextButton.icon(
          onPressed: _showAddContractorAddressDialog,
          icon: const Icon(Icons.add),
          label: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Ajouter une adresse'),
          ),
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            foregroundColor: Colors.green[800],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    return menuChildren;
  }

  void _selectAddress(String address) {
    setState(() {
      selectContractorAddress(address);
    });
    _menuController.close();
  }

  Future<void> _showAddContractorAddressDialog() async {
    _menuController.close();

    final focusNode = FocusNode();
    final controller = TextEditingController();
    String? errorText;
    final screenWidth = MediaQuery.of(context).size.width;

    final newAddress = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return KeyboardListener(
              focusNode: focusNode,
              onKeyEvent: (KeyEvent event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.escape) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Dialog(
                child: Container(
                  width: screenWidth * 2 / 3,
                  height: MediaQuery.of(dialogContext).size.height / 2,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SuperTitle(
                        title: 'Ajouter une adresse',
                        color: Colors.green,
                        fontSize: 45,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          'Utilisez "$contractorAddressLineDelimiter" pour forcer un saut de ligne dans le contrat.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.green[900],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomFormField(
                        color: Colors.green,
                        icon: Icons.store,
                        textSize: 42,
                        width: screenWidth * 2 / 3 - 100,
                        label: 'Nouvelle adresse',
                        hintText: 'Route de Sainte-Cecile | 84830 SERIGNAN',
                        initValue: controller.text,
                        controller: controller,
                        onChanged: (String _) {
                          if (errorText != null) {
                            setDialogState(() {
                              errorText = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      if (errorText != null)
                        Text(
                          errorText!,
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TravelButton(
                            color: Colors.red,
                            icon: Icons.close,
                            label: 'Annuler',
                            roundedBorder: 16,
                            height: 110 * screenWidth / 1920,
                            width: screenWidth / 4.8,
                            textSize: 34 * screenWidth / 1920,
                            actionFunction: () {
                              Navigator.of(dialogContext).pop();
                            },
                            scaleWidthFactor: 1,
                          ),
                          const SizedBox(width: 20),
                          TravelButton(
                            color: Colors.green,
                            icon: Icons.add,
                            label: 'Ajouter',
                            roundedBorder: 16,
                            height: 110 * screenWidth / 1920,
                            width: screenWidth / 4.3,
                            textSize: 34 * screenWidth / 1920,
                            actionFunction: () {
                              final address =
                                  normalizeContractorAddress(controller.text);
                              if (address.isEmpty) {
                                setDialogState(() {
                                  errorText =
                                      'L\'adresse ne peut pas etre vide.';
                                });
                                return;
                              }

                              if (contractorAddresses.contains(address)) {
                                setDialogState(() {
                                  errorText =
                                      'Cette adresse existe deja dans le .contrapp.';
                                });
                                return;
                              }

                              Navigator.of(dialogContext).pop(address);
                            },
                            scaleWidthFactor: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    focusNode.dispose();
    controller.dispose();

    if (newAddress == null) {
      return;
    }

    final wasAdded = await addContractorAddress(newAddress);
    if (!mounted) {
      return;
    }

    if (wasAdded) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adresse vide : aucun ajout effectue')),
      );
    }
  }

  Future<void> _confirmRemoveContractorAddress(String address) async {
    _menuController.close();

    final focusNode = FocusNode();
    final screenWidth = MediaQuery.of(context).size.width;

    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return KeyboardListener(
          focusNode: focusNode,
          onKeyEvent: (KeyEvent event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.escape) {
              Navigator.of(dialogContext).pop(false);
            }
          },
          child: Dialog(
            child: Container(
              width: screenWidth * 2 / 3,
              height: MediaQuery.of(dialogContext).size.height / 2,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SuperTitle(
                    title: 'Suppression',
                    color: Colors.red,
                    fontSize: 45,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Supprimer cette adresse ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red[800],
                              size: 34,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Cette suppression est destructive et definitive. Elle sera retiree du .contrapp pour les prochaines sessions.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red[800],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          formatContractorAddressForContract(address),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TravelButton(
                        color: Colors.grey,
                        icon: Icons.undo,
                        label: 'Annuler',
                        roundedBorder: 16,
                        height: 110 * screenWidth / 1920,
                        width: screenWidth / 4.8,
                        textSize: 34 * screenWidth / 1920,
                        actionFunction: () {
                          Navigator.of(dialogContext).pop(false);
                        },
                        scaleWidthFactor: 1,
                      ),
                      const SizedBox(width: 20),
                      TravelButton(
                        color: Colors.red,
                        icon: Icons.delete,
                        label: 'Supprimer',
                        roundedBorder: 16,
                        height: 110 * screenWidth / 1920,
                        width: screenWidth / 4.3,
                        textSize: 34 * screenWidth / 1920,
                        actionFunction: () {
                          Navigator.of(dialogContext).pop(true);
                        },
                        scaleWidthFactor: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    focusNode.dispose();

    if (shouldRemove != true) {
      return;
    }

    await removeContractorAddress(address);
    if (!mounted) {
      return;
    }
    setState(() {});
  }
}
