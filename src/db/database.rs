use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use crate::graphql::users::User;

pub struct Database {
    pub users: Arc<Mutex<HashMap<String, User>>>,
}

impl Database {
    pub fn new() -> Self {
        Database {
            users: Arc::new(Mutex::new(HashMap::new())),
        }
    }

    pub fn seed(&self) {
        let mut users = self.users.lock().unwrap();
        users.clear();
        
        // Add test user
        let test_user = User {
            id: "1".to_string(),
            username: "test_user".to_string(),
            password_hash: "$2b$12$uDMbBQqwEm90ug6iypB0.O4p/70nrGPxnFjEL/ozBFbuxffUMtdqu".to_string(), // password: test123
            is_admin: false,
            bio: Some("I'm a test user!".to_string()),
        };
        users.insert(test_user.id.clone(), test_user);

        // Add admin user
        let admin_user = User {
            id: "admin".to_string(),
            username: "admin_user".to_string(),
            password_hash: "$2b$12$oqcv/8ieLYGdViDhlSPF8OTBG94EoHF8AZZSsWKJHJXoGkGrQZC9G".to_string(), // password: admin123
            is_admin: true,
            bio: Some("I'm the admin!".to_string()),
        };
        users.insert(admin_user.id.clone(), admin_user);
    }

    pub fn reset_and_seed(&self) {
        self.seed();
    }
} 