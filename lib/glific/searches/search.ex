defmodule Glific.Searches.Search do
  @moduledoc """
  The Glific Abstraction to represent the conversation with a user. This unifies a vast majority of the
  glific data types including: message, contact, and tag
  """
  alias __MODULE__

  use Ecto.Schema

  alias Glific.{Contacts.Contact, Messages.Message}

  @type t() :: %__MODULE__{
          contacts: [Contact.t()],
          messages: [Message.t()],
          tags: [Message.t()],
          labels: [Message.t()]
        }

  # structure to hold a contact and the conversations with the contact
  # the messages should be in descending order, i.e. most recent ones first
  embedded_schema do
    embeds_many(:contacts, [Contact])
    embeds_many(:messages, [Message])
    embeds_many(:tags, [Message])
    embeds_many(:labels, [Message])
  end

  @doc """
  Create a new conversation. A contact is required for the conversation. Messages can
  be added later on
  """
  @spec new(list(), list(), list(), list()) :: Search.t()
  def new(contacts, messages, tags, labels) do
    %Search{contacts: contacts, messages: messages, tags: tags, labels: labels}
  end
end
