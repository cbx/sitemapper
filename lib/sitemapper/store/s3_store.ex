defmodule Sitemapper.S3Store do
  @behaviour Sitemapper.Store

  def write(filename, body, config) do
    bucket = Keyword.fetch!(config, :bucket)
    region = Keyword.get(config, :region, "us-east-1")
    cache_control = Keyword.get(config, :cache_control, "must-revalidate")

    props = [
      {:content_type, content_type(filename)},
      {:cache_control, cache_control},
      {:acl, :public_read}
    ]

    ExAws.S3.put_object(bucket, filename, body, props)
    |> ExAws.request!(region: region)

    :ok
  end

  defp content_type(filename) do
    if String.ends_with?(filename, ".gz") do
      "application/x-gzip"
    else
      "application/xml"
    end
  end
end
