from PIL import Image, ImageOps, ImageDraw

def create_rounded_favicon(input_path, output_path, size=(512, 512)):
    try:
        # Open the image
        img = Image.open(input_path)
        
        # Convert to RGB to ensure consistency
        img = img.convert("RGB")
        
        # Calculate dimensions for a center crop
        width, height = img.size
        new_size = min(width, height)
        
        left = (width - new_size) / 2
        top = (height - new_size) / 2
        right = (width + new_size) / 2
        bottom = (height + new_size) / 2
        
        # Crop to square
        img = img.crop((left, top, right, bottom))
        
        # Resize to desired size (high res for favicon is good)
        img = img.resize(size, Image.Resampling.LANCZOS)
        
        # Create a mask for the circular crop
        mask = Image.new('L', size, 0)
        draw = ImageDraw.Draw(mask)
        draw.ellipse((0, 0) + size, fill=255)
        
        # Add alpha channel to image
        output = Image.new('RGBA', size, (0, 0, 0, 0))
        output.paste(img, (0, 0), mask=mask)
        
        # Save as PNG
        output.save(output_path, "PNG")
        print(f"Successfully created {output_path}")
        
    except Exception as e:
        print(f"Error creating favicon: {e}")

if __name__ == "__main__":
    create_rounded_favicon("Profile Picture Ion.jpg", "favicon.png")
