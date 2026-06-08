# reset_db.exs
# Veritabanını sıfırlamak için Elixir script
# Kullanım: mix run reset_db.exs

# Çevre değişkenlerini yükle
Code.require_file("lib/dukkadee/env.ex")
Dukkadee.Env.load_env()

# Veritabanı bilgilerini al
db_name = System.get_env("POSTGRES_DB") || "dukkadee_dev"
db_user = System.get_env("POSTGRES_USER") || "postgres"
db_pass = System.get_env("POSTGRES_PASSWORD") || "20911980"
db_host = System.get_env("POSTGRES_HOST") || "localhost"

IO.puts("Veritabanı sıfırlanıyor: #{db_name}")
IO.puts("Kullanıcı: #{db_user}")
IO.puts("Host: #{db_host}")

# Aktif bağlantıları sonlandır
terminate_cmd =
  "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '#{db_name}' AND pid <> pg_backend_pid();"

System.cmd("psql", ["-U", db_user, "-h", db_host, "-c", terminate_cmd, "postgres"],
  env: [{"PGPASSWORD", db_pass}]
)

IO.puts("Aktif bağlantılar sonlandırıldı.")

# Veritabanını sil
drop_cmd = "DROP DATABASE IF EXISTS #{db_name};"

System.cmd("psql", ["-U", db_user, "-h", db_host, "-c", drop_cmd, "postgres"],
  env: [{"PGPASSWORD", db_pass}]
)

IO.puts("Veritabanı silindi.")

# Veritabanını yeniden oluştur
create_cmd = "CREATE DATABASE #{db_name} OWNER #{db_user};"

System.cmd("psql", ["-U", db_user, "-h", db_host, "-c", create_cmd, "postgres"],
  env: [{"PGPASSWORD", db_pass}]
)

IO.puts("Veritabanı yeniden oluşturuldu.")

IO.puts("\nVeritabanı sıfırlama işlemi tamamlandı.")
IO.puts("Şimdi göçleri çalıştırabilirsiniz: mix ecto.migrate")
