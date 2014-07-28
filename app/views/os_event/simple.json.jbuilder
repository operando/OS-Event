json.array!(@events) do |event|
  json.id          event.id
  json.title       event.title
  json.url         event.url
  json.address     event.address
  json.start_time  event.start_time
  json.end_time    event.end_time
  json.event_site  event.event_site
  json.created_at  event.created_at
  json.updated_at  event.updated_at
end
