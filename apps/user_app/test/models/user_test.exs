defmodule UserApp.UserTest do
  use UserApp.ModelCase, async: true

  alias UserApp.User

  test "user with valid attributes" do
    changeset = User.registration_changeset(%User{}, %{username: "john-doe", password: "johndoe"})

    assert changeset.valid?
  end

  test "user with missing username" do
    changeset = User.registration_changeset(%User{}, %{password: "johndoe"})

    {error_message, _} = changeset.errors[:username]

    assert error_message == "can't be blank"
    refute changeset.valid?
  end

  test "user with missing password" do
    changeset = User.registration_changeset(%User{}, %{username: "johndoe"})

    {error_message, _} = changeset.errors[:password]

    assert error_message == "can't be blank"
    refute changeset.valid?
  end

  test "user with too short username" do
    changeset = User.registration_changeset(%User{}, %{username: "j", password: "johndoe"})

    {error_message, _} = changeset.errors[:username]

    assert error_message == "should be at least %{count} character(s)"
    refute changeset.valid?
  end

  test "user with too long username" do
    long_username = "very long username is invalid"

    changeset = User.registration_changeset(%User{}, %{username: long_username, password: "johndoe"})

    {error_message, _} = changeset.errors[:username]

    assert error_message == "should be at most %{count} character(s)"
    refute changeset.valid?
  end

  test "user with too short password" do
    changeset = User.registration_changeset(%User{}, %{username: "johndoe", password: "p"})

    {error_message, _} = changeset.errors[:password]

    assert error_message == "should be at least %{count} character(s)"
    refute changeset.valid?
  end

  test "user with too long password" do
    long_password = "very long password is invalid"

    changeset = User.registration_changeset(%User{}, %{username: "johndoe", password: long_password})

    {error_message, _} = changeset.errors[:password]

    assert error_message == "should be at most %{count} character(s)"
    refute changeset.valid?
  end
end
