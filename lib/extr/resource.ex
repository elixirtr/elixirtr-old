defmodule Extr.Resource do
  @moduledoc """
  The Resource context.
  """

  import Ecto.Query, warn: false
  alias Extr.Repo

  alias Extr.Resource.Tutorial

  @doc """
  Returns the list of tutorials.

  ## Examples

      iex> list_tutorials()
      [%Tutorial{}, ...]

  """
  def list_tutorials do
    Repo.all(Tutorial)
  end

  @doc """
  Gets a single tutorial.

  Raises `Ecto.NoResultsError` if the Tutorial does not exist.

  ## Examples

      iex> get_tutorial!(123)
      %Tutorial{}

      iex> get_tutorial!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tutorial!(id), do: Repo.get!(Tutorial, id)

  @doc """
  Creates a tutorial.

  ## Examples

      iex> create_tutorial(%{field: value})
      {:ok, %Tutorial{}}

      iex> create_tutorial(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tutorial(attrs \\ %{}) do
    %Tutorial{}
    |> Tutorial.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tutorial.

  ## Examples

      iex> update_tutorial(tutorial, %{field: new_value})
      {:ok, %Tutorial{}}

      iex> update_tutorial(tutorial, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tutorial(%Tutorial{} = tutorial, attrs) do
    tutorial
    |> Tutorial.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tutorial.

  ## Examples

      iex> delete_tutorial(tutorial)
      {:ok, %Tutorial{}}

      iex> delete_tutorial(tutorial)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tutorial(%Tutorial{} = tutorial) do
    Repo.delete(tutorial)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tutorial changes.

  ## Examples

      iex> change_tutorial(tutorial)
      %Ecto.Changeset{source: %Tutorial{}}

  """
  def change_tutorial(%Tutorial{} = tutorial) do
    Tutorial.changeset(tutorial, %{})
  end
end
