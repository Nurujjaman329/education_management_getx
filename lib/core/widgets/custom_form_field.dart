import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomFormField extends FormField<String> {
  CustomFormField({
    Key? key,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    String? initialValue,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    bool readOnly = false,
    bool enabled = true,
    bool autoFocus = false,
    int? maxLines = 1,
    int? minLines,
    int? maxLength,
    bool expands = false,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    Color focusedBorderColor = AppColors.primary,
    Color enabledBorderColor = Colors.grey,
    double borderRadius = 12.0,
    double borderWidth = 1.5,
    String? counterText,
    String? helperText,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    VoidCallback? onTap,
    bool isPasswordField = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    bool enableInteractiveSelection = true,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: controller == null ? initialValue : null,
          builder: (FormFieldState<String> state) {
            final theme = Theme.of(state.context);
            final effectiveFocusNode = focusNode ?? FocusNode();

            final isFocused = effectiveFocusNode.hasFocus;
            final showLabel = labelText != null && labelText.trim().isNotEmpty;

            final border = OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: enabledBorderColor,
                width: borderWidth,
              ),
            );

            final focusedBorder = OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: focusedBorderColor,
                width: borderWidth + 0.5,
              ),
            );

            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: focusedBorderColor.withOpacity(0.12),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showLabel)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: RichText(
                        text: TextSpan(
                          text: labelText,
                          style: labelStyle ??
                              theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                              ),
                          children: [
                            if (validator != null)
                              const TextSpan(
                                text: ' *',
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    ),
                  TextFormField(
                    controller: controller,
                    focusNode: effectiveFocusNode,
                    onChanged: (val) {
                      state.didChange(val);
                      onChanged?.call(val);
                    },
                    obscureText: obscureText,
                    keyboardType:
                        isPasswordField ? TextInputType.visiblePassword : keyboardType,
                    readOnly: readOnly,
                    enabled: enabled,
                    autofocus: autoFocus,
                    maxLines: maxLines,
                    minLines: minLines,
                    maxLength: maxLength,
                    expands: expands,
                    autocorrect: autocorrect,
                    enableSuggestions: enableSuggestions,
                    enableInteractiveSelection: enableInteractiveSelection,
                    textCapitalization: textCapitalization,
                    onTap: onTap,
                    onFieldSubmitted: onFieldSubmitted,
                    inputFormatters: inputFormatters,
                    textInputAction: textInputAction,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      helperText: helperText,
                      errorText: state.errorText,
                      counterText: counterText,
                      prefixIcon: prefixIcon != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: IconTheme(
                                data: IconThemeData(
                                  color:
                                      theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                                child: prefixIcon,
                              ),
                            )
                          : null,
                      suffixIcon: suffixIcon != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: IconTheme(
                                data: IconThemeData(
                                  color:
                                      theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                                child: suffixIcon,
                              ),
                            )
                          : null,
                      hintStyle: hintStyle ??
                          theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                      contentPadding: contentPadding ??
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: border,
                      enabledBorder: border,
                      focusedBorder: focusedBorder,
                      errorBorder: border.copyWith(
                        borderSide: BorderSide(
                          color: theme.colorScheme.error,
                          width: borderWidth,
                        ),
                      ),
                      focusedErrorBorder: focusedBorder.copyWith(
                        borderSide: BorderSide(
                          color: theme.colorScheme.error,
                          width: borderWidth + 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

  @override
  FormFieldState<String> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends FormFieldState<String> {
  @override
  CustomFormField get widget => super.widget as CustomFormField;
}
