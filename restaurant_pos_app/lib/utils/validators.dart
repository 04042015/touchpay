class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }
    
    return null;
  }

  // Strong password validation
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Name validation
  static String? validateName(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters long';
    }
    
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return '$fieldName can only contain letters and spaces';
    }
    
    return null;
  }

  // Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    
    if (digitsOnly.length > 15) {
      return 'Phone number must be less than 15 digits';
    }
    
    return null;
  }

  // Price validation
  static String? validatePrice(String? value, {String fieldName = 'Price'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid $fieldName';
    }
    
    if (price < 0) {
      return '$fieldName cannot be negative';
    }
    
    if (price == 0) {
      return '$fieldName must be greater than zero';
    }
    
    // Check for reasonable decimal places (max 2)
    if (value.contains('.') && value.split('.')[1].length > 2) {
      return '$fieldName can have at most 2 decimal places';
    }
    
    return null;
  }

  // Quantity validation
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }
    
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid quantity';
    }
    
    if (quantity <= 0) {
      return 'Quantity must be greater than zero';
    }
    
    if (quantity > 999) {
      return 'Quantity cannot exceed 999';
    }
    
    return null;
  }

  // Discount validation
  static String? validateDiscount(String? value, {bool isPercentage = false}) {
    if (value == null || value.isEmpty) {
      return null; // Discount is optional
    }
    
    final discount = double.tryParse(value);
    if (discount == null) {
      return 'Please enter a valid discount';
    }
    
    if (discount < 0) {
      return 'Discount cannot be negative';
    }
    
    if (isPercentage && discount > 100) {
      return 'Discount percentage cannot exceed 100%';
    }
    
    return null;
  }

  // Table capacity validation
  static String? validateTableCapacity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Table capacity is required';
    }
    
    final capacity = int.tryParse(value);
    if (capacity == null) {
      return 'Please enter a valid capacity';
    }
    
    if (capacity <= 0) {
      return 'Capacity must be greater than zero';
    }
    
    if (capacity > 50) {
      return 'Capacity cannot exceed 50 people';
    }
    
    return null;
  }

  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    
    if (value.length > 20) {
      return 'Username cannot exceed 20 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    
    if (value.startsWith('_') || value.endsWith('_')) {
      return 'Username cannot start or end with underscore';
    }
    
    return null;
  }

  // Menu item description validation
  static String? validateDescription(String? value, {int maxLength = 500}) {
    if (value == null || value.isEmpty) {
      return null; // Description is optional
    }
    
    if (value.length > maxLength) {
      return 'Description cannot exceed $maxLength characters';
    }
    
    return null;
  }

  // Tax rate validation
  static String? validateTaxRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tax rate is required';
    }
    
    final taxRate = double.tryParse(value);
    if (taxRate == null) {
      return 'Please enter a valid tax rate';
    }
    
    if (taxRate < 0) {
      return 'Tax rate cannot be negative';
    }
    
    if (taxRate > 100) {
      return 'Tax rate cannot exceed 100%';
    }
    
    return null;
  }

  // Credit card number validation (basic)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }
    
    // Remove spaces and dashes
    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');
    
    if (!RegExp(r'^\d+$').hasMatch(cardNumber)) {
      return 'Credit card number can only contain digits';
    }
    
    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'Credit card number must be between 13 and 19 digits';
    }
    
    // Luhn algorithm check
    if (!_isValidLuhn(cardNumber)) {
      return 'Invalid credit card number';
    }
    
    return null;
  }

  // Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    
    if (value.trim().length < 5) {
      return 'Address must be at least 5 characters long';
    }
    
    if (value.length > 200) {
      return 'Address cannot exceed 200 characters';
    }
    
    return null;
  }

  // URL validation
  static String? validateUrl(String? value, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? 'URL is required' : null;
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  // Helper method for Luhn algorithm
  static bool _isValidLuhn(String cardNumber) {
    int sum = 0;
    bool isEven = false;
    
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      
      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + (digit ~/ 10);
        }
      }
      
      sum += digit;
      isEven = !isEven;
    }
    
    return sum % 10 == 0;
  }

  // Composite validator for multiple rules
  static String? validateMultiple(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  // Min length validator
  static String? Function(String?) minLength(int length, {String fieldName = 'Field'}) {
    return (String? value) {
      if (value == null || value.length < length) {
        return '$fieldName must be at least $length characters long';
      }
      return null;
    };
  }

  // Max length validator
  static String? Function(String?) maxLength(int length, {String fieldName = 'Field'}) {
    return (String? value) {
      if (value != null && value.length > length) {
        return '$fieldName cannot exceed $length characters';
      }
      return null;
    };
  }

  // Custom regex validator
  static String? Function(String?) regex(RegExp pattern, String errorMessage) {
    return (String? value) {
      if (value != null && !pattern.hasMatch(value)) {
        return errorMessage;
      }
      return null;
    };
  }
}
