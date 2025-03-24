import boto3
from PIL import Image
import io

s3 = boto3.client('s3')

def lambda_handler(event, context):
    source_bucket = "raw-images-bucket"
    destination_bucket = "processed-images-bucket"

    for record in event['Records']:
        file_name = record['s3']['object']['key']
        file_obj = s3.get_object(Bucket=source_bucket, Key=file_name)
        image = Image.open(io.BytesIO(file_obj['Body'].read()))

        # Convert image to grayscale
        image = image.convert('L')

        # Save the processed image
        buffer = io.BytesIO()
        image.save(buffer, "PNG")
        buffer.seek(0)

        s3.put_object(Bucket=destination_bucket, Key=file_name, Body=buffer)
        print(f"Processed {file_name} and saved to {destination_bucket}")

    return {"status": "Success"}

