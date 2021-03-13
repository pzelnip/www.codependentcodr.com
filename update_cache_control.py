"""Tool for setting the cache-control header on items in an S3 bucket."""

# pylint: disable=import-error
import boto3

# pylint: enable=import-error

SESSION = boto3.Session(profile_name="codependentcodr")
CLIENT = SESSION.client("s3")
CACHEABLE_TYPES = ["png", "jpeg", "jpg", "css", "js", "gif"]
SECONDS_IN_A_WEEK = 60 * 60 * 24 * 7
CACHE_CONTROL_SETTING = f"public, max-age={SECONDS_IN_A_WEEK}"


def update_file(bucket, key):
    """Sets the cache-control header on the item in the bucket."""
    if any(key.endswith(cache_type) for cache_type in CACHEABLE_TYPES):
        item = CLIENT.head_object(Bucket=bucket, Key=key)
        cache_control = item.get("CacheControl", None)
        content_type = item.get("ContentType", None)

        if not cache_control:
            print(
                f"No Cache Control set for {bucket}/{key}, updating to {CACHE_CONTROL_SETTING}"
            )
            CLIENT.copy_object(
                Bucket=bucket,
                Key=key,
                CopySource=bucket + "/" + key,
                CacheControl=CACHE_CONTROL_SETTING,
                ContentType=content_type,
                Metadata=item["Metadata"],
                MetadataDirective="REPLACE",
            )
            return True
    return False


def process_bucket(bucket):
    """For all items in the given bucket, apply update_file."""
    print(f"Processing {bucket}...")

    paginator = CLIENT.get_paginator("list_objects_v2")
    page_iterator = paginator.paginate(Bucket=bucket)

    count = 0
    for page in page_iterator:
        for item in page["Contents"]:
            key = item["Key"]
            if update_file(bucket, key):
                count += 1

    print(f"Updated count: {count}")


if __name__ == "__main__":
    process_bucket("www.codependentcodr.com")
    # update_file('www.codependentcodr.com', 'static/imgs/cloudfront-behaviour-1.png')
