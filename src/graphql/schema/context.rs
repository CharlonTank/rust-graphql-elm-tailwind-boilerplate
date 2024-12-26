use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use serde::{Deserialize, Serialize};
use crate::graphql::users::User;

#[derive(Clone)]
pub struct Context {
    pub users: Arc<Mutex<HashMap<String, User>>>,
    pub jwt_secret: String,
    pub admin_password: String,
}

impl juniper::Context for Context {}

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub is_admin: bool,
    pub exp: usize,
} 