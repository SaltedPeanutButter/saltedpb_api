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
    let port = std::env::var("PORT")
        .unwrap_or("3000".into());
    let addr = format!("0.0.0.0:{port}");
    
    Server::bind(&addr.parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}