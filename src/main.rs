use axum::{Router, routing::get, Server};

#[tokio::main]
async fn main() {
    // Initialise tracing
    tracing_subscriber::fmt::init();

    // Build test app
    let app = Router::new()
        .route("/", get(|| async {
            "Deployment successful!"
        }));

    // Run app
    Server::bind(&"0.0.0.0:3000".parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}