defmodule DukkadeeWeb.HelloController do
  use DukkadeeWeb, :controller

  def index(conn, _params) do
    html(conn, """
    <html>
    <head>
      <title>Dukkadee Test Page</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          max-width: 800px;
          margin: 0 auto;
          padding: 20px;
          line-height: 1.6;
        }
        h1 { color: #4F46E5; }
        .card {
          background: #f9fafb;
          border-radius: 8px;
          padding: 20px;
          margin: 20px 0;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
      </style>
    </head>
    <body>
      <h1>Dukkadee E-Commerce Platform</h1>
      <div class="card">
        <h2>Hello World!</h2>
        <p>If you can see this page, your Phoenix application is running properly.</p>
        <p>Current time: #{DateTime.utc_now() |> DateTime.to_string()}</p>
      </div>
    </body>
    </html>
    """)
  end
end
