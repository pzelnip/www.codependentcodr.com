Title: This Changes Everything....
Date: 2017-03-29 22:12
tags: aws,ec2,ebs
cover: static/imgs/default_page_imagev2.jpg

The other day our staging environment at work ran out of space on the EBS volume holding our MongoDb data.  The fun part
about Mongo is that when you get to the point that there's no space left because Mongo's filled it, the Mongo shell will
reject commands with "Can't take a write lock while out of disk space".  This includes commands like say,
`db.dropDatabase` to try and reclaim some of that said precious disk space.

Enter AWS, and how freaking amazing it is: you can now (as of around Feb 2017) resize an EBS volume without even
shutting down the instance it's attached to.

Very handy for moments like this, I was able to double the size of the volume, without even powering down the instance
or even stopping the Mongodb service.

Details of the new EBS resizing: <https://aws.amazon.com/blogs/aws/amazon-ebs-update-new-elastic-volumes-change-everything/>
