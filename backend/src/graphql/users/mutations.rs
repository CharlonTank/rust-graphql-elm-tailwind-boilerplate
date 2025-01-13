use bcrypt::{hash, verify, DEFAULT_COST};
use juniper::FieldResult;
use uuid::Uuid;
use crate::graphql::schema::{Context, Claims};
use super::types::User;
use super::input_types::{SignupInput, LoginInput, AdminLoginInput};

pub struct UserMutations;

#[juniper::graphql_object(Context = Context)]
impl UserMutations {
    pub fn signup(context: &Context, input: SignupInput) -> FieldResult<String> {
        let mut users = context.users.lock().unwrap();
        
        // Check if username already exists
        if users.values().any(|u| u.username == input.username) {
            return Err(juniper::FieldError::new(
                "Username already taken",
                juniper::Value::Null,
            ));
        }

        // Hash password
        let password_hash = hash(input.password.as_bytes(), DEFAULT_COST)?;

        // Create new user
        let user = User {
            id: Uuid::new_v4().to_string(),
            username: input.username,
            password_hash,
            is_admin: false,
            bio: None,
        };

        let user_id = user.id.clone();
        users.insert(user.id.clone(), user);

        // Generate JWT
        let claims = Claims {
            sub: user_id,
            is_admin: false,
            exp: (chrono::Utc::now() + chrono::Duration::hours(24)).timestamp() as usize,
        };

        let token = jsonwebtoken::encode(
            &jsonwebtoken::Header::default(),
            &claims,
            &jsonwebtoken::EncodingKey::from_secret(context.jwt_secret.as_bytes()),
        )?;

        Ok(token)
    }

    pub fn login(context: &Context, input: LoginInput) -> FieldResult<String> {
        let users = context.users.lock().unwrap();
        
        // Find user by username
        let user = users
            .values()
            .find(|u| u.username == input.username)
            .ok_or_else(|| {
                juniper::FieldError::new("Invalid credentials", juniper::Value::Null)
            })?;

        // Verify password
        if !verify(input.password.as_bytes(), &user.password_hash)? {
            return Err(juniper::FieldError::new(
                "Invalid credentials",
                juniper::Value::Null,
            ));
        }

        // Generate JWT
        let claims = Claims {
            sub: user.id.clone(),
            is_admin: user.is_admin,
            exp: (chrono::Utc::now() + chrono::Duration::hours(24)).timestamp() as usize,
        };

        let token = jsonwebtoken::encode(
            &jsonwebtoken::Header::default(),
            &claims,
            &jsonwebtoken::EncodingKey::from_secret(context.jwt_secret.as_bytes()),
        )?;

        Ok(token)
    }

    pub fn admin_login(context: &Context, input: AdminLoginInput) -> FieldResult<String> {
        // Verify admin password
        if input.password != context.admin_password {
            return Err(juniper::FieldError::new(
                "Invalid admin credentials",
                juniper::Value::Null,
            ));
        }

        // Generate admin JWT
        let claims = Claims {
            sub: "admin".to_string(),
            is_admin: true,
            exp: (chrono::Utc::now() + chrono::Duration::hours(24)).timestamp() as usize,
        };

        let token = jsonwebtoken::encode(
            &jsonwebtoken::Header::default(),
            &claims,
            &jsonwebtoken::EncodingKey::from_secret(context.jwt_secret.as_bytes()),
        )?;

        Ok(token)
    }
} 