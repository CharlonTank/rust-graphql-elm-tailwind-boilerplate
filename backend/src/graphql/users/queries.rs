use juniper::FieldResult;
use crate::graphql::schema::Context;
use super::types::User;
use jsonwebtoken::{decode, DecodingKey, Validation};
use crate::graphql::schema::Claims;
use actix_web::http::header::AUTHORIZATION;

pub struct UserQueries;

#[juniper::graphql_object(Context = Context)]
impl UserQueries {
    pub fn users(context: &Context) -> FieldResult<Vec<User>> {
        // Get the Authorization header from the context
        let auth_header = context.request_headers
            .get(AUTHORIZATION)
            .and_then(|h| h.to_str().ok())
            .and_then(|h| h.strip_prefix("Bearer "));

        let token = match auth_header {
            Some(token) => token,
            None => return Err(juniper::FieldError::new(
                "Authentication required",
                juniper::Value::Null,
            )),
        };

        // Verify JWT token
        let token_data = decode::<Claims>(
            token,
            &DecodingKey::from_secret(context.jwt_secret.as_bytes()),
            &Validation::default(),
        ).map_err(|_| juniper::FieldError::new(
            "Invalid token",
            juniper::Value::Null,
        ))?;

        let users = context.users.lock().unwrap();
        
        // Return only the authenticated user's data
        if let Some(user) = users.get(&token_data.claims.sub) {
            Ok(vec![user.clone()])
        } else {
            Err(juniper::FieldError::new(
                "User not found",
                juniper::Value::Null,
            ))
        }
    }
} 