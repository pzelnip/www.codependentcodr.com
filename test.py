import urllib.parse

import boto3

session = boto3.Session(profile_name='codependentcodr')
client = session.client('s3')


CACHEABLE_TYPES = ['png', 'jpeg', 'jpg', 'css', 'js', 'gif']
SECONDS_IN_A_WEEK = 60 * 60 * 24 * 7
CACHE_CONTROL_SETTING = f'public, max-age={SECONDS_IN_A_WEEK}'


def update_file(bucket, key):
    if any(key.endswith(cache_type) for cache_type in CACHEABLE_TYPES):
        item = client.head_object(Bucket=bucket, Key=key)
        metadata = item["Metadata"]
        cache_control = item.get('CacheControl', None)

        if not cache_control:
            print(f"No Cache Control set for {bucket}/{key}, updating to {CACHE_CONTROL_SETTING}")
            # client.copy_object(Bucket=bucket, Key=key, CopySource=bucket + '/' + key,
            #                    CacheControl=CACHE_CONTROL_SETTING,
            #                    Metadata=metadata,
            #                    MetadataDirective='REPLACE')
            return True
    return False


def process_bucket(bucket):
    print(f"Processing {bucket}...")

    paginator = client.get_paginator('list_objects_v2')
    page_iterator = paginator.paginate        (Bucket=bucket)

    count = 0
    for page in page_iterator:
        for item in page['Contents']:
            key = item['Key']
            if update_file(bucket, key):
                count += 1

    print(f"Updated count: {count}")
if __name__ == "__main__":
    process_bucket('www.codependentcodr.com')
