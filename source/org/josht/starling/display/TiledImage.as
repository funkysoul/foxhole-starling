package org.josht.starling.display
{
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class TiledImage extends Sprite
	{
		public function TiledImage(texture:Texture)
		{
			super();
			this.texture = texture;
		}
		
		private var _imageContainer:Sprite;
		private var _images:Vector.<Image> = new <Image>[];
		
		private var _width:Number = 100;
		
		override public function get width():Number
		{
			return this._width;
		}
		
		override public function set width(value:Number):void
		{
			if(this._width == value)
			{
				return;
			}
			this._width = value;
			this.refreshImages();
		}
		
		private var _height:Number = 100;
		
		override public function get height():Number
		{
			return this._height;
		}
		
		override public function set height(value:Number):void
		{
			if(this._height == value)
			{
				return;
			}
			this._height = value;
			this.refreshImages();
		}
		
		private var _texture:Texture;
		
		public function get texture():Texture
		{
			return this._texture;
		}
		
		public function set texture(value:Texture):void 
		{ 
			if(value == null)
			{
				throw new ArgumentError("Texture cannot be null");
			}
			else if(value != this._texture)
			{
				this._texture = value;
				this.refreshImages();
			}
		}
			
		private var _smoothing:String = TextureSmoothing.BILINEAR;
		
		public function get smoothing():String
		{
			return this._smoothing;
		}
		
		public function set smoothing(value:String):void 
		{
			if(TextureSmoothing.isValid(value))
			{
				this._smoothing = value;
			}
			else
			{
				throw new ArgumentError("Invalid smoothing mode: " + smoothing);
			}
			this.refreshImageProperties();
		}
		
		private var _textureScale:Number = 1;

		public function get textureScale():Number
		{
			return this._textureScale;
		}

		public function set textureScale(value:Number):void
		{
			if(this._textureScale == value)
			{
				return;
			}
			this._textureScale = value;
			this.refreshImages();
		}
		
		public function setSize(width:Number, height:Number):void
		{
			this._width = width;
			this._height = height;
			this.refreshImages();
		}

		private function refreshImages():void
		{
			const scaledTextureWidth:Number = Math.floor(this._texture.width * this._textureScale);
			const scaledTextureHeight:Number = Math.floor(this._texture.height * this._textureScale);
			const xImageCount:int = Math.ceil(this._width / scaledTextureWidth);
			const yImageCount:int = Math.ceil(this._height / scaledTextureHeight);
			const imageCount:int = xImageCount * yImageCount;
			const loopCount:int = Math.max(this._images.length, imageCount);
			
			for(var i:int = 0; i < loopCount; i++)
			{
				if(i < imageCount && this._images.length < imageCount)
				{
					var image:Image = new Image(this._texture);
					this.addChild(image);
					this._images.push(image);
				}
				else if(i >= imageCount)
				{
					image = this._images.pop();
					image.removeFromParent(true);
				}
				else
				{
					image = this._images[i];
					image.texture = this._texture;
				}
			}
			
			this.refreshImageProperties();
			this.refreshLayout();
		}
		
		private function refreshImageProperties():void
		{
			for each(var image:Image in this._images)
			{
				image.smoothing = this._smoothing;
			}
		}
		
		private function refreshLayout():void
		{
			const scaledTextureWidth:Number = Math.floor(this._texture.width * this._textureScale);
			const scaledTextureHeight:Number = Math.floor(this._texture.height * this._textureScale);
			var xPosition:Number = 0;
			var yPosition:Number = 0;
			const imageCount:int = this._images.length;
			for(var i:int = 0; i < imageCount; i++)
			{
				var image:Image = this._images[i];
				image.x = xPosition;
				image.y = yPosition;
				image.scaleX = image.scaleY = this._textureScale;
				xPosition += scaledTextureWidth;
				if(xPosition >= this._width)
				{
					xPosition = 0;
					yPosition += scaledTextureHeight;
				}
			}
		}
	}
}