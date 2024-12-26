mod graphql;
mod db;

use actix_cors::Cors;
use actix_web::{middleware, web, App, HttpResponse, HttpServer};
use dotenv::dotenv;
use std::env;
use std::sync::Arc;

use crate::graphql::{Schema, Context, create_schema};
use crate::db::Database;

async fn graphql(
    req: actix_web::HttpRequest,
    payload: actix_web::web::Payload,
    schema: web::Data<Arc<Schema>>,
    context: web::Data<Context>,
) -> Result<HttpResponse, actix_web::Error> {
    juniper_actix::graphql_handler(&schema, &context, req, payload).await
}

async fn graphql_playground() -> Result<HttpResponse, actix_web::Error> {
    juniper_actix::playground_handler("/graphql", None).await
}

async fn reset_db(db: web::Data<Arc<Database>>) -> HttpResponse {
    db.reset_and_seed();
    HttpResponse::Ok().body("Database reset and seeded successfully!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // Load environment variables
    dotenv().ok();

    let jwt_secret = env::var("JWT_SECRET").expect("JWT_SECRET must be set");
    let admin_password = env::var("ADMIN_PASSWORD").expect("ADMIN_PASSWORD must be set");

    // Create and seed database
    let database = Arc::new(Database::new());
    database.reset_and_seed();

    // Create application state
    let context = Context {
        users: Arc::clone(&database.users),
        jwt_secret,
        admin_password,
    };

    // Create Schema
    let schema = Arc::new(create_schema());

    println!("GraphQL server starting at http://localhost:8080/graphql");
    println!("GraphQL Playground available at http://localhost:8080/playground");
    println!("To reset and reseed the database, visit http://localhost:8080/reset-db");

    // Start server
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(Arc::clone(&schema)))
            .app_data(web::Data::new(context.clone()))
            .app_data(web::Data::new(Arc::clone(&database)))
            .wrap(
                Cors::default()
                    .allow_any_origin()
                    .allow_any_method()
                    .allow_any_header(),
            )
            .wrap(middleware::Logger::default())
            .service(
                web::resource("/graphql")
                    .route(web::post().to(graphql))
                    .route(web::get().to(graphql_playground)),
            )
            .service(web::resource("/playground").route(web::get().to(graphql_playground)))
            .service(web::resource("/reset-db").route(web::get().to(reset_db)))
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}
