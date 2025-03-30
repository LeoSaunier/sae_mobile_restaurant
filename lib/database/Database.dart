import 'package:postgres/postgres.dart';

class Database {
  static Connection? _connection;

  static Future<Connection> getConnection() async {
    if (_connection == null) {
      final endpoint = Endpoint(
        host: 'aws-0-eu-west-3.pooler.supabase.com', // Hôte
        port: 6543, // Port
        database: 'postgres', // Nom de la base de données
        username: 'postgres.dhhugougxeqqjglegovv', // Nom d'utilisateur
        password: 'root', // Mot de passe
      );
      _connection = await Connection.open(endpoint);
    }
    return _connection!;
  }
}
