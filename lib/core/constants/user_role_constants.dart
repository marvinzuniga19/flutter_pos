class UserRoleConstants {
  // User roles hierarchy
  static const String roleAdmin = 'admin';
  static const String roleManager = 'manager';
  static const String roleCashier = 'cashier';
  static const String roleInventory = 'inventory';

  // Role display names (Spanish)
  static const Map<String, String> roleNames = {
    roleAdmin: 'Administrador',
    roleManager: 'Gerente',
    roleCashier: 'Cajero',
    roleInventory: 'Inventario',
  };

  // Role permissions
  static const Map<String, List<String>> rolePermissions = {
    roleAdmin: [
      'users.create',
      'users.read',
      'users.update',
      'users.delete',
      'sales.create',
      'sales.read',
      'sales.update',
      'sales.delete',
      'inventory.create',
      'inventory.read',
      'inventory.update',
      'inventory.delete',
      'customers.create',
      'customers.read',
      'customers.update',
      'customers.delete',
      'products.create',
      'products.read',
      'products.update',
      'products.delete',
      'reports.read',
      'reports.export',
      'settings.read',
      'settings.update',
    ],
    roleManager: [
      'sales.create',
      'sales.read',
      'sales.update',
      'inventory.create',
      'inventory.read',
      'inventory.update',
      'customers.create',
      'customers.read',
      'customers.update',
      'products.create',
      'products.read',
      'products.update',
      'reports.read',
      'reports.export',
      'users.read',
    ],
    roleCashier: [
      'sales.create',
      'sales.read',
      'customers.read',
      'customers.create',
      'products.read',
      'inventory.read',
    ],
    roleInventory: [
      'inventory.create',
      'inventory.read',
      'inventory.update',
      'products.create',
      'products.read',
      'products.update',
      'reports.read',
    ],
  };

  // Check if role has permission
  static bool hasPermission(String role, String permission) {
    final permissions = rolePermissions[role];
    return permissions?.contains(permission) ?? false;
  }

  // Get all permissions for a role
  static List<String> getPermissions(String role) {
    return rolePermissions[role] ?? [];
  }
}
