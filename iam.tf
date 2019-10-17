resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "SSMInstanceProfile"
  role = "${aws_iam_role.ssm_instance_profile_role.name}"
}

resource "aws_iam_role" "ssm_instance_profile_role" {
  name = "SSMInstanceProfileRole"
  description = "Allows EC2 instances to call AWS services on your behalf."
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
              "Service": "ec2.amazonaws.com"
          }
      }
    ]
}
EOF
  force_detach_policies = true
}

resource "aws_iam_policy" "ssm-s3-policy" {
  name = "ssm-s3-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": [
                "arn:aws:s3:::aws-ssm-${data.aws_region.current.name}/*",
                "arn:aws:s3:::aws-windows-downloads-${data.aws_region.current.name}/*",
                "arn:aws:s3:::amazon-ssm-${data.aws_region.current.name}/*",
                "arn:aws:s3:::amazon-ssm-packages-${data.aws_region.current.name}/*",
                "arn:aws:s3:::${data.aws_region.current.name}-birdwatcher-prod/*",
                "arn:aws:s3:::patch-baseline-snapshot-${data.aws_region.current.name}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetEncryptionConfiguration"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.ssm-log-bucket.bucket}/*",
                "arn:aws:s3:::${aws_s3_bucket.ssm-log-bucket.bucket}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm-s3-policy-attach" {
  role       = "${aws_iam_role.ssm_instance_profile_role.name}"
  policy_arn = "${aws_iam_policy.ssm-s3-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "ssm-management-instance-core-attach" {
  role       = "${aws_iam_role.ssm_instance_profile_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}