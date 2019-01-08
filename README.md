# README

Run `bin/setup` to run the necessary commands to get the server ready to run.

This demo just uses [local disk storage](https://github.com/nicedawg/activestorage-demo/blob/master/config/storage.yml)
for attachments, but hopefully it would just work with other supported storage
backends.

Some thoughts about using activestorage:

* By default, each request for an attachment causes the browser to make *two*
  requests:

  * first, a request that hits the Rails app to find the appropriate ActiveStorage::Blob record
  * then, a request to actually retrieve the attachment content from the configured backend service

* Custom URLs

  Since we want custom URLs for SEO, we don't want that initial request to
  redirect -- we need it to directly return the image. So I created
  [`AttachmentsController`](https://github.com/nicedawg/activestorage-demo/blob/master/app/controllers/attachments_controller.rb)
  to do so.

  I also used POROs (see
  [`MemeImage::Default`](https://github.com/nicedawg/activestorage-demo/blob/master/app/models/meme_image/default.rb),
  for example) to represent each image -- probably mostly for
    [views](https://github.com/nicedawg/activestorage-demo/blob/master/app/views/memes/show.html.erb)
  to use to generate image tags and links. This is where we would define a slug
  for a particular attachment.

* Variants

  The most common usage of variants involves creating them ad-hoc, on the fly,
  in views by specifying the desired transformations in the [view](https://github.com/nicedawg/activestorage-demo/blob/master/app/views/memes/show.html.erb#L2://github.com/nicedawg/activestorage-demo/blob/master/app/views/memes/show.html.erb#L21))

  That usage would make maintainability harder, and doesn't facilitate having
  custom URLs for variants of an image. So I used POROs (see
  [`MemeImage::Thumbnail`](https://github.com/nicedawg/activestorage-demo/blob/master/app/models/meme_image/thumbnail.rb),
  for an example) to encapsulate the behavior of that variant, which has the
  benefit of enforcing the usage of class names in views, as opposed to strings
  like "100x100." (much easier to search for!).

  The use of POROs also allows the `AttachmentsController` to return the content
  for the correct variant in the initial request,
  *as long as the*
  [fragile naming convention](https://github.com/nicedawg/activestorage-demo/blob/master/app/services/fetch_attachment.rb#L52)
  *is followed*. :-|


  One caveat: since attachment variants are ad-hoc with ActiveStorage -- and
  since the content is stored in an un-human-friendly file structure, it can be
  tricky to delete unwanted variants. POROs might help us here, since we could
  define a method called `old_variant_config` on a class, and run a
  job/migration to call purge (or whatever) on whichever clearly defined
  variants of whichever models we want:

  ```!ruby
  Meme.active.find_each do |meme|
    # NOTE: This is pseudo-code: it'd probably be something sort of like this
    ActiveStorage::Blob.purge(Meme::Thumbnail.new(meme).old_variant_config)
  end

  ```

* Redirects

  It may be the case (for SEO) that we wish to have a canonical URL for an
  attachment (or one of its variants). `AttachmentsController` will redirect to
  the canonical slug.

  The way this currently works depends on the attachment's id to be present in
  the URL.

* Translations

  Generating translated attachment URLs:
    As long as the PORO that represents our attachment defines the slug in a
    locale-friendly way, this should be no problem.

  Handling translated attachment URLs:
    Since our routing mechanism depends on the attachment id being present in
    the URL, this will just work as long as the slug is locale-friendly.

* Performance

  Not sure how this would work with a CDN or caching reverse-proxy -- *but it
  will need one!*. The response from `AttachmentsController` could probably
  benefit from some HTTP cache headers.

* Validations

  ActiveStorage doesn't offer any validations support. There is a gem out there
  that adds validations, but I added a couple of
  [validators}(https://github.com/nicedawg/activestorage-demo/tree/master/app/lib)
  which I found on Google.

