w:
	flutter pub get
	flutter packages pub run build_runner watch --delete-conflicting-outputs

clean:
	flutter clean
	flutter pub get
