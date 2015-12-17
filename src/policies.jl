### RandomPolicy ###
# a generic policy that uses the actions function to create a list of actions
# and then randomly samples an action from it.
type RandomPolicy <: Policy
    rng::AbstractRNG
    problem::POMDP
    action_space # stores the action space so that it does not have to be reallocated each time
end
# The constructor below should be used to create the policy so that the action space is initialized correctly
RandomPolicy(problem::POMDP; rng=MersenneTwister()) = RandomPolicy(rng, problem, actions(problem))

## policy execution ##
function action(policy::RandomPolicy, b::Belief, action::Action)
    actions(policy.problem, b, policy.action_space)
    return rand!(policy.rng, action, policy.action_space)
end
action(policy::RandomPolicy, b::Belief) = action(policy, b, create_action(policy.problem))
function action(policy::RandomPolicy, b::State, action::Action)
    actions(policy.problem, b, policy.action_space)
    return rand!(policy.rng, action, policy.action_space)
end
action(policy::RandomPolicy, b::State) = action(policy, b, create_action(policy.problem))


### Random Solver ###
# solver that produces a random policy
type RandomSolver <: Solver
    rng::AbstractRNG
end
RandomSolver(;rng=MersenneTwister(rand(UInt32))) = RandomSolver(rng)
solve(solver::RandomSolver, problem::POMDP, policy::RandomPolicy=create_policy(solver, problem)) = policy
create_policy(solver::RandomSolver, problem::POMDP) = RandomPolicy(problem, rng=solver.rng)