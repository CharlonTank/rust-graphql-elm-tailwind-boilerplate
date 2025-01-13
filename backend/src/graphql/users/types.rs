use serde::{Deserialize, Serialize};
use juniper::GraphQLObject;

#[derive(Clone, Debug, Serialize, Deserialize, GraphQLObject)]
pub struct User {
    pub id: String,
    pub username: String,
    #[graphql(skip)]
    pub password_hash: String,
    pub is_admin: bool,
    pub bio: Option<String>,
} 