use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use serde::{Deserialize, Serialize};
use actix_web::http::header::HeaderMap;
use crate::graphql::users::User;

#[derive(Clone)]
pub struct Context {
    pub users: Arc<Mutex<HashMap<String, User>>>,
    pub jwt_secret: String,
    pub admin_password: String,
    pub request_headers: HeaderMap,
}

impl juniper::Context for Context {}

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub is_admin: bool,
    pub exp: usize,
} 