# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    return if user.blank?

    # recupera o account_user para pegar o ROLE do usuário da conta
    account_user = user.account_users.find_by(account: user.account)
    return if account_user.blank?

    # Se a conta for pessoal ou usuário ADMIN (procfy)
    if user.account.personal? || user.admin?
      can :manage, :all
      # Remove o acesso para adicionar novos usuários quando a conta for pessoal
      if user.account.personal?
        cannot :manage, AccountUser
        cannot :manage, AccountInvitation
      end

    # Se a conta for business, segue a regra do perfilamento padrão
    else
      # Add authorization from user ROLE
      case account_user.role
      when :admin
        # Pode fazer tudo
        can :manage, :all
      when :user
        # Pode fazer tudo menos gerenciar convites, usuários e configurações da conta
        can :manage, :all
        cannot :manage, Account
        cannot :manage, AccountInvitation
        cannot :manage, AccountUser
      else
        # Permite que qualquer usuário tenha acesso somente leitura/consulta
        can :read, :all
        cannot :read, Account
        cannot :read, AccountInvitation
        cannot :read, AccountUser
      end
    end

    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
