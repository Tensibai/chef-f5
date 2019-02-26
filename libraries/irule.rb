require_relative './base_client'

module ChefF5
  class IRule < BaseClient
    def missing?(name)
      Chef::Log.warn 'Within missing'
      !api.LocalLB.Rule.get_list[:item].include?(with_partition(name))
    end

    def create(name, definition)
      Chef::Log.warn 'Within create'
      api.LocalLB.Rule.create(rules: { item: [{ rule_name: with_partition(name), rule_definition: definition }] })
    end

    def definition_changed?(name, definition)
      current = api.LocalLB.Rule.query_rule(rule_names: { item: [with_partition(name)] })
      current[:item][:rule_definition] != definition
    end

    def update_definition(name, definition)
      api.LocalLB.Rule.modify_rule(rules: { item: [{ rule_name: with_partition(name), rule_definition: definition }] })
    end

    def destroy(name)
      api.LocalLB.Rule.delete_rule(rule_names: { item: [with_partition(name)] })
    end
  end
end
