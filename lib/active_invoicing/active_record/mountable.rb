# frozen_string_literal: true

require "active_support/concern"

module ActiveInvoicing
  module ActiveRecord
    module Mountable
      extend ActiveSupport::Concern

      included do
        class_attribute :_mounted_accounting_models, default: {}
        # after_save :sync_to_mounted_accounting_models TODO: Implement this
      end

      module ClassMethods
        def mounts_accounting_model(name, class_name:, external_id_column:, connection_method: nil, mapper: nil, sync_on_save: false)
          name = name.to_sym
          class_name = class_name.to_s
          connection_method = connection_method&.to_sym || default_connection_method(name)
          external_id_column = external_id_column.to_sym

          self._mounted_accounting_models = _mounted_accounting_models.merge(
            name => {
              class_name: class_name,
              connection_method: connection_method,
              external_id_column: external_id_column,
              mapper: mapper,
            },
          )

          define_method(name) do
            config = self.class._mounted_accounting_models[name]
            return unless config

            external_id = public_send(config[:external_id_column])
            return unless external_id

            accounting_class = config[:class_name].constantize
            connection = public_send(config[:connection_method])
            return unless connection

            accounting_class.fetch_by_id(external_id, connection)
          end

          define_method("#{name}=") do |accounting_model|
            return unless accounting_model

            config = self.class._mounted_accounting_models[name]
            return unless config

            external_id = accounting_model.external_id
            public_send("#{config[:external_id_column]}=", external_id) if external_id
          end

          define_method("sync_to_#{name}") do
            config = self.class._mounted_accounting_models[name]
            return unless config

            accounting_model = public_send(name)
            return unless accounting_model

            attributes = if config[:mapper]
              instance_exec(accounting_model, &config[:mapper])
            else
              default_map_to_accounting_model(accounting_model)
            end

            attributes.each do |key, value|
              setter = "#{key}=".to_sym
              accounting_model.public_send(setter, value) if accounting_model.respond_to?(setter)
            end
            accounting_model.save if accounting_model.respond_to?(:save)
            accounting_model
          end

          define_method("sync_from_#{name}") do
            config = self.class._mounted_accounting_models[name]
            return unless config

            accounting_model = public_send(name)
            return unless accounting_model

            attributes = if config[:mapper]
              instance_exec(accounting_model, &config[:mapper])
            else
              default_map_from_accounting_model(accounting_model)
            end

            assign_attributes(attributes)
            save
            self
          end
        end

        private

        def default_connection_method(name)
          "#{name}_connection"
        end
      end

      private

      def default_map_to_accounting_model(accounting_model)
        attributes = {}
        # just some common attributes
        [:name, :email, :first_name, :last_name, :company_name].each do |attr|
          if respond_to?(attr) && accounting_model.respond_to?("#{attr}=")
            value = public_send(attr)
            attributes[attr] = value if value.present?
          end
        end
        attributes
      end

      def default_map_from_accounting_model(accounting_model)
        attributes = {}
        # just some common attributes
        [:name, :email, :first_name, :last_name].each do |attr|
          if accounting_model.respond_to?(attr) && respond_to?("#{attr}=")
            value = accounting_model.public_send(attr)
            attributes[attr] = value if value.present?
          end
        end
        attributes
      end
    end
  end
end
