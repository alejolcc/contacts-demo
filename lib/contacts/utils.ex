defmodule Contacts.Utils do
  @moduledoc false

  # TODO: Correct way to log the calling module

  require Logger

  def debug(msg) do
    Logger.debug fn -> msg end
  end

  def warn(msg) do
    Logger.warn fn -> msg end
  end
end
