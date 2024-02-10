defmodule ParentWeb.UserJSON do
  alias Parent.Families.Users.User

  def data(%User{} = user) do
    %{
      type: :user,
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      family_id: user.family_id
    }
  end
end
