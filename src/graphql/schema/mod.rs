mod context;

use juniper::{EmptySubscription, RootNode};
use crate::graphql::users::{UserQueries, UserMutations};

pub use context::{Context, Claims};

#[derive(Clone)]
pub struct Query;

#[juniper::graphql_object(Context = Context)]
impl Query {
    fn users() -> UserQueries {
        UserQueries
    }
}

#[derive(Clone)]
pub struct Mutation;

#[juniper::graphql_object(Context = Context)]
impl Mutation {
    fn users() -> UserMutations {
        UserMutations
    }
}

pub type Schema = RootNode<'static, Query, Mutation, EmptySubscription<Context>>;

pub fn create_schema() -> Schema {
    Schema::new(Query, Mutation, EmptySubscription::new())
} 